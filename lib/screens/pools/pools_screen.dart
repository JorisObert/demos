import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/filter/filter_screen.dart';
import 'package:demos/utils/constants.dart';
import 'package:demos/widgets/filter_bar.dart';
import 'package:demos/widgets/pool_item_widget/pool_item.dart';
import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:geopoint/geopoint.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'components/no_more_pools_screen.dart';

class PoolsScreen extends StatefulWidget {
  final VoidCallback anonymousClick;

  const PoolsScreen({Key? key, required this.anonymousClick}) : super(key: key);

  @override
  _PoolsScreenState createState() => _PoolsScreenState();
}

class _PoolsScreenState extends State<PoolsScreen>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();

  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _initPoolsFlow();
  }

  //We're getting pools, asking if user agree location and if so, reload
  void _initPoolsFlow() async {
    if (context.read<DemosUserProvider>().isLoggedIn) {
      Location location = new Location();

      bool hasService = await location.serviceEnabled();

      if (!hasService) {
        hasService = await location.requestService();
      }

      location.onLocationChanged.listen((locationData) {
        context.read<PoolProvider>().filters[LOCATION_KEY] = GeoJsonPoint(
            geoPoint: GeoPoint(
                latitude: locationData.latitude!,
                longitude: locationData.longitude!));
      });

      if (hasService) {
        var permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            location.getLocation();
          }
        } else {
          location.getLocation();
        }
      }

      if (context.read<DemosUserProvider>().isLoggedIn) {
        context
            .read<PoolProvider>()
            .setUserId(userId: context.read<DemosUserProvider>().user!.id!);
        context.read<PoolProvider>().initFilters();
        context.read<PoolProvider>().applyFilters();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LoadingState loadingState =
        context.select((PoolProvider p) => p.loadingState);
    List<Pool> pools = context.watch<PoolProvider>().pools;

    return Column(
      children: [
        //FilterBar(),
        Expanded(
          child: loadingState == LoadingState.LOADING
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        return await context
                            .read<PoolProvider>()
                            .refreshPools();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      child: PageView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: pools.length,
                        controller: _pageController,
                        pageSnapping: true,
                        onPageChanged: (index) {
                          if (pools.isNotEmpty &&
                              pools.last.id != POOL_EMPTY_ID &&
                              index >= pools.length - 1) {
                            context.read<PoolProvider>().loadMore();
                          }
                          setState(() {
                            _isLastPage = index == pools.length - 1;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return pools[index].id != POOL_EMPTY_ID
                              ? PoolItem(
                                  pool: pools[index],
                                  choices: pools[index].choices!,
                                  anonymousClick: widget.anonymousClick,
                                )
                              : NoMorePoolsScreen();
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 24, right: 16, child: _nextPoolBtn(pools)),
                    loadingState == LoadingState.LOAD_MORE
                        ? Positioned(
                            bottom: 32,
                            left: 0,
                            right: 0,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _nextPoolBtn(List<Pool> pools) {
    return OutlinedButton(
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
        side: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondaryVariant),
        //padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),

        primary: Theme.of(context).colorScheme.secondaryVariant,
      ),
      child: Icon(
        _isLastPage ? Icons.expand_less : Icons.expand_more,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
    return InkWell(
      onTap: () {
        _isLastPage
            ? _pageController.animateToPage(0,
                duration: Duration(seconds: 1), curve: Curves.decelerate)
            : _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
      },
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryVariant,
            )),
        child: Icon(
          _isLastPage ? Icons.expand_less : Icons.expand_more,
          color: Theme.of(context).colorScheme.secondaryVariant,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
