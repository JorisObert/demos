import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:demos/models/demos_user.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/main/main_screen.dart';
import 'package:demos/screens/pools/components/generic_pool_list.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'components/empty_pool.dart';

class DeepNavigationPoolScreen extends StatefulWidget {
  final String? hashtag;
  final DemosUser? demosUser;
  final String? searchTerms;

  const DeepNavigationPoolScreen(
      {Key? key, this.searchTerms, this.demosUser, this.hashtag})
      : super(key: key);

  @override
  _DeepNavigationPoolScreenState createState() =>
      _DeepNavigationPoolScreenState();
}

class _DeepNavigationPoolScreenState extends State<DeepNavigationPoolScreen> {
  List<Pool> _pools = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  final PageController _pageController = PageController();

  bool _isLastPage = false;

  bool _hasNoPools = false;

  @override
  void initState() {
    _pageController.addListener(() {});
    super.initState();
  }

  void _onRefresh() async {
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
    print('pools length is ${_pools.length}');
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(_getBarTitle, style: TextStyle(fontSize: 16)),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              scrollDirection: Axis.vertical,
              header: MaterialClassicHeader(),
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
          Positioned(
              bottom: 32,
              right: 32,
              child: _nextPoolBtn()),
        ],
      ),
    );
  }

  Widget _nextPoolBtn() {
    return _pools.length > 1 ? OutlinedButton(
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
            width: 1, color: Theme.of(context).colorScheme.secondaryVariant),
        //padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),

        primary: Theme.of(context).colorScheme.secondaryVariant,
      ),
      child: Icon(
        _isLastPage ? Icons.expand_less : Icons.expand_more,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    ):SizedBox.shrink();
  }

  Future<ApiResponse> get _apiResponse {
    if (widget.hashtag != null) {
      return context.read<PoolProvider>().getPoolsByHashtag(
          hashtag: widget.hashtag!,
          userId: context.read<DemosUserProvider>().firebaseUser!.uid,
          offset: _refreshController.isRefresh ? 0 : _pools.length);
    } else if (widget.demosUser != null) {
      return context.read<PoolProvider>().getUserPools(
          loggedUserId: widget.demosUser!.id!,
          offset: _refreshController.isRefresh ? 0 : _pools.length);
    } else {
      return context.read<PoolProvider>().getPoolsByGenericSearch(
          userId: context.read<DemosUserProvider>().firebaseUser!.uid,
          searchTerms: widget.searchTerms!,
          offset: _refreshController.isRefresh ? 0 : _pools.length);
    }
  }

  String get _getBarTitle{
    if(widget.hashtag != null){
      return '#${widget.hashtag}';
    }else if(widget.searchTerms != null){
      return 'Results for "widget.searchTerms"';
    }else if(widget.demosUser != null){
      return 'Pools from ${widget.demosUser!.displayName ?? ''}';
    }
      return '';
  }
}
