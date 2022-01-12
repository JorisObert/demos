import 'package:auto_size_text/auto_size_text.dart';
import 'package:demos/models/choice.dart';
import 'package:demos/models/pool.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/filter/filter_screen.dart';
import 'package:demos/screens/login/login_screen.dart';
import 'package:demos/screens/main/components/create_pool_dialog.dart';
import 'package:demos/screens/pools/pools_screen.dart';
import 'package:demos/services/api_calls.dart';
import 'package:demos/utils/constants.dart';
import 'package:demos/widgets/app_logo.dart';
import 'package:demos/widgets/user_picture.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/src/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _pageIndex = 0;

  late TabController _myTabController;

  late PanelController _panelController;
  late PanelController _loginPanelController;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _myTabController = new TabController(
      vsync: this,
      length: 4,
    );
    _panelController = PanelController();
    _loginPanelController = PanelController();
    _myTabController.addListener(_handleTabSelection);
    _animationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        animationBehavior: AnimationBehavior.preserve);
  }

  void _handleTabSelection() {
    setState(() {
      if (_pageIndex != _myTabController.index) {
        _pageIndex = _myTabController.index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.black,
        /*title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.audiotrack,
                color: Colors.lightBlue,
              ),
            ],
          ),*/
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Center(
          child: AppLogo(
            size: 24.0,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<FilterChoice>(
            onSelected: _handleClick,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            icon: Icon(
              Icons.place,
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
            itemBuilder: (BuildContext context) {
              return choices.map((FilterChoice choice) {
                return PopupMenuItem<FilterChoice>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(choice.icon),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        choice.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          TabBarView(
            children: [
              PoolsScreen(anonymousClick: () {
                _loginPanelController.open();
              }),
              Container(),
              CreatePoolScreen(),
              Container(),
            ],
            controller: _myTabController,
          ),
          _loginPanel(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: (_pageIndex == 0)
                        ? Theme.of(context).colorScheme.secondaryVariant
                        : Colors.white,
                  ),
                  onPressed: () {
                    this._myTabController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: (_pageIndex == 1)
                        ? Theme.of(context).colorScheme.secondaryVariant
                        : Colors.white,
                  ),
                  onPressed: () {
                    this._myTabController.animateTo(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: (_pageIndex == 2)
                        ? Theme.of(context).colorScheme.secondaryVariant
                        : Colors.white,
                  ),
                  onPressed: () {
                    this._myTabController.animateTo(2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                ),
                GestureDetector(
                    onTap: () {
                      this._myTabController.animateTo(3,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: UserPicture(
                        url: context
                            .read<DemosUserProvider>()
                            .user
                            ?.profilePicUrl))
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget _loginPanel() {
    return SlidingUpPanel(
      controller: _loginPanelController,
      isDraggable: false,
      panel: LoginScreen(
        onClosed: () => _loginPanelController.close(),
      ),
      color: Colors.grey.shade800,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          kBottomNavigationBarHeight -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
    );
  }

  void _handleClick(FilterChoice filterChoice) {
    switch (filterChoice.filterChoiceId) {
      case FilterChoiceId.NEW:
        // TODO: Handle this case.
        break;
      case FilterChoiceId.MY_VOTES:
        // TODO: Handle this case.
        break;
      case FilterChoiceId.MY_POOLS:
        // TODO: Handle this case.
        break;
      case FilterChoiceId.CLOSE:
        // TODO: Handle this case.
        break;
    }
  }
}

class FilterChoice {
  final String title;
  final IconData icon;
  final FilterChoiceId filterChoiceId;

  FilterChoice(
      {required this.title, required this.icon, required this.filterChoiceId});
}

List<FilterChoice> choices = <FilterChoice>[
  FilterChoice(
      title: 'New',
      icon: Icons.auto_awesome,
      filterChoiceId: FilterChoiceId.NEW),
  FilterChoice(
      title: 'Hot', icon: Icons.whatshot, filterChoiceId: FilterChoiceId.NEW),
  FilterChoice(
      title: 'My votes',
      icon: Icons.person,
      filterChoiceId: FilterChoiceId.MY_VOTES),
  FilterChoice(
      title: 'My pools',
      icon: Icons.people,
      filterChoiceId: FilterChoiceId.MY_POOLS),
  FilterChoice(
      title: 'Close to me',
      icon: Icons.place,
      filterChoiceId: FilterChoiceId.CLOSE),
];

enum FilterChoiceId { NEW, MY_VOTES, MY_POOLS, CLOSE }
