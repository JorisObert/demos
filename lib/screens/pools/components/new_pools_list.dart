import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewPoolsList extends StatefulWidget {
  NewPoolsList({Key? key}) : super(key: key);

  @override
  State<NewPoolsList> createState() => _NewPoolsListState();
}

class _NewPoolsListState extends State<NewPoolsList> {
  List<Pool> _pools = [];

  RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  void _onRefresh() async{
    print('refreshing');
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale.countryCode);
    print(myLocale.languageCode);
    ApiResponse apiResponse = await context.read<PoolProvider>()
        .getNewPools(
            myLocale.countryCode,
            myLocale.languageCode,
            context.read<DemosUserProvider>().user!.id!);

    if(apiResponse.apiResponseStatus == ApiResponseStatus.SUCCESS){
      _pools.addAll(apiResponse.data);
      _refreshController.refreshCompleted();
    }else{
      _refreshController.refreshFailed();
    }

  }

  void _onLoading() async{
    print('loading');
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale.countryCode);
    print(myLocale.languageCode);
    ApiResponse apiResponse = await context.read<PoolProvider>()
        .getNewPools(
        myLocale.countryCode,
        myLocale.languageCode,
        context.read<DemosUserProvider>().user!.id!);

    if(apiResponse.apiResponseStatus == ApiResponseStatus.SUCCESS){
      _pools.addAll(apiResponse.data);
      _refreshController.loadComplete();
    }else{
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus? mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (context, index) => PoolItem(
            pool: _pools[index],
            choices: _pools[index].choices!,
            anonymousClick: (){
              print('click anonymous');
            },
          ),
          itemCount: _pools.length,
        ),
      ),
    );
  }
}
