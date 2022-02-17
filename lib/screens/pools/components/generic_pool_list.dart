import 'package:collection/src/iterable_extensions.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/main/main_screen.dart';
import 'package:demos/screens/pools/components/empty_pool.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenericPoolList extends StatefulWidget {
  GenericPoolList({Key? key, required this.stream}) : super(key: key);

  Stream<FilterChoiceId> stream;

  @override
  State<GenericPoolList> createState() => _GenericPoolListState();
}

class _GenericPoolListState extends State<GenericPoolList> {
  List<Pool> _pools = [];

  FilterChoiceId _filterChoiceId = FilterChoiceId.NEW;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  final PageController _pageController = PageController();

  bool _isLastPage = false;

  bool _hasNoPools = false;

  @override
  void initState() {
    widget.stream.listen((filterChoiceId) {
      setState(() {
        _pools.clear();
        _filterChoiceId = filterChoiceId;
        _refreshController.requestRefresh();
      });
    });
    _pageController.addListener(() {
      setState(() {
        _isLastPage = _pageController.page == _pools.length - 1;
      });
    });
    super.initState();
  }

  void _onRefresh() async {
    print('refreshing');
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale.countryCode);
    print(myLocale.languageCode);
    ApiResponse apiResponse = await _apiResponse;

    print('refresh api response is: ${apiResponse.toString()}');

    if (apiResponse.apiResponseStatus == ApiResponseStatus.SUCCESS) {
      for(Pool pool in apiResponse.data){
        if(_pools.firstWhereOrNull((e)=>e.id == pool.id)==null){
          _pools.insert(0, pool);
        }
      }
      _hasNoPools = _pools.isEmpty;
      if (mounted) setState(() {});
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    print('loading');
    ApiResponse apiResponse = await _apiResponse;

    print('loading api response is: ${apiResponse.toString()}');

    if (apiResponse.apiResponseStatus == ApiResponseStatus.SUCCESS) {
      _pools.addAll(apiResponse.data);
      if (mounted) setState(() {});
      if(apiResponse.data.isNotEmpty){
        _refreshController.loadComplete();
      }else{
        _refreshController.loadNoData();
      }
    } else {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              scrollDirection: Axis.vertical,
              header: MaterialClassicHeader(

              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                idleText: '',
                idleIcon: SizedBox.shrink(),
                canLoadingText: 'Load more',
              ),

              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _hasNoPools ? EmptyPool() : CustomScrollView(
                controller: _pageController,
                physics: PageScrollPhysics(),
                slivers: <Widget>[
                  SliverFillViewport(
                      delegate: SliverChildListDelegate(_pools
                          .map((pool) => PoolItem(
                              pool: pool,
                          hasVoted: (){
                            Future.delayed(Duration(seconds: 1),(){
                              _pageController.nextPage(duration: Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                            });
                          },
                              anonymousClick: () => print('click'),
                              choices: pool.choices!))
                          .toList()))
                ],
              ),
            ),
          ),
          Positioned(bottom: 32, right: 32, child: _nextPoolBtn())
        ],
      ),
    );
  }

  Widget _nextPoolBtn() {
    return _pools.length > 1
        ? OutlinedButton(
            onPressed: () {
              _isLastPage
                  ? _pageController.animateToPage(0,
                      duration: Duration(seconds: 1), curve: Curves.decelerate)
                  : _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
            },
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(),
              side: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondaryVariant),
              //padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),

              primary: Theme.of(context).colorScheme.secondaryVariant,
            ),
            child: Icon(
              _isLastPage ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
          )
        : SizedBox.shrink();
  }

  Future<ApiResponse> get _apiResponse {
    switch (_filterChoiceId) {
      case FilterChoiceId.NEW:
        Locale myLocale = Localizations.localeOf(context);

        return context.read<PoolProvider>().getNewPools(
            countryCode: myLocale.countryCode,
            languageCode: myLocale.languageCode,
            loggedUserId: context.read<DemosUserProvider>().firebaseUser?.uid,
            offset: _refreshController.isRefresh ? 0 : _pools.length);

      case FilterChoiceId.MY_VOTES:
        return context.read<PoolProvider>().getMyVotes(
            loggedUserId: context.read<DemosUserProvider>().firebaseUser!.uid,
            offset: _refreshController.isRefresh ? 0 : _pools.length);
      case FilterChoiceId.MY_POOLS:
        return context.read<PoolProvider>().getUserPools(
            loggedUserId: context.read<DemosUserProvider>().firebaseUser!.uid,
            offset: _refreshController.isRefresh ? 0 : _pools.length);
      case FilterChoiceId.CLOSE:
        return context.read<PoolProvider>().getPoolsByLocation(
            userId: context.read<DemosUserProvider>().firebaseUser?.uid,
            offset: _refreshController.isRefresh ? 0 : _pools.length);
      case FilterChoiceId.HOT:
        Locale myLocale = Localizations.localeOf(context);

        return context.read<PoolProvider>().getHotPools(
            countryCode: myLocale.countryCode,
            languageCode: myLocale.languageCode,
            loggedUserId: context.read<DemosUserProvider>().firebaseUser?.uid,
            offset: _refreshController.isRefresh ? 0 : _pools.length);
    }
  }
}
