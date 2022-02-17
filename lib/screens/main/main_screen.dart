import 'dart:async';

import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/account/account_screen.dart';
import 'package:demos/screens/login/login_screen.dart';
import 'package:demos/screens/create_pool/create_pool_screen.dart';
import 'package:demos/screens/pools/deep_navigation_pool_screen.dart';
import 'package:demos/screens/pools/pools_screen.dart';
import 'package:demos/widgets/app_logo.dart';
import 'package:demos/widgets/auth_button.dart';
import 'package:demos/widgets/user_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/src/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late PanelController _panelController;
  late PanelController _loginPanelController;

  late AnimationController _animationController;

  TextEditingController _searchController = TextEditingController();

  bool _searchPanelVisible = false;

  StreamController<FilterChoiceId> _controller = StreamController<FilterChoiceId>();

  FilterChoice _currentFilterChoice = choices[0];


  @override
  void initState() {
    super.initState();

    _panelController = PanelController();
    _loginPanelController = PanelController();
    _animationController = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        animationBehavior: AnimationBehavior.preserve);
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
          IconButton(
            icon: Icon(
              Icons.search,
              color: _searchPanelVisible ? Theme.of(context).colorScheme.secondaryVariant : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _searchPanelVisible = !_searchPanelVisible;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          new PoolsScreen(
              stream: _controller.stream,
              anonymousClick: () {
            _loginPanelController.open();
          }),
          _searchBar(),
          _loginPanel(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PopupMenuButton<FilterChoice>(
                      onSelected: _handleClick,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                      icon: Icon(_currentFilterChoice.icon),
                      itemBuilder: (BuildContext context) {
                        return choices.map((FilterChoice choice) {
                          return PopupMenuItem<FilterChoice>(
                            value: choice,
                            child: Row(
                              children: [
                                Icon(choice.icon, color: _currentFilterChoice.filterChoiceId == choice.filterChoiceId ? Theme.of(context).colorScheme.secondaryVariant : Colors.white,),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  choice.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: _currentFilterChoice.filterChoiceId == choice.filterChoiceId ? Theme.of(context).colorScheme.secondaryVariant : Colors.white,),
                                ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    AuthButton(
                      authStatus: (status){
                        switch(status){
                          case AuthStatus.ANONYMOUS:
                            _loginPanelController.open();
                            break;
                          case AuthStatus.LOGGED:
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AccountScreen()),
                            );
                            break;
                        }
                      },

                        child: UserPicture(
                            url: context
                                .read<DemosUserProvider>()
                                .user
                                ?.profilePicUrl))
                  ],
                ),
              ),
              Positioned(
                left: 0,
                height: 64,
                right: 0,
                bottom: 16,
                child: Center(
                  child: AuthButton(
                    authStatus: (authStatus){
                      switch(authStatus){
                        case AuthStatus.ANONYMOUS:
                          _loginPanelController.open();
                          break;
                        case AuthStatus.LOGGED:
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => CreatePoolScreen()),
                          );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: Theme.of(context).colorScheme.secondaryVariant,
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        onLoggedIn: ()=> _loginPanelController.close(),
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

  Widget _searchBar() {
    return Visibility(
      visible: _searchPanelVisible,
      child: Positioned.fill(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'hashtag, pool, username...',
                        suffix: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => DeepNavigationPoolScreen(
                                      searchTerms: _searchController.text,
                                    )),
                              );
                            },
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondaryVariant),
                            )),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      ),
                      cursorColor: Theme.of(context).colorScheme.secondaryVariant,
                      style: TextStyle(color: Colors.grey.shade900),
                      autofocus: true,
                    ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      _searchPanelVisible = false;
                    });
                  }, icon: Icon(Icons.close))
                ],
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.black87,
            ))
          ],
        ),
      ),
    );
  }

  void _handleClick(FilterChoice filterChoice) async{
    switch (filterChoice.filterChoiceId) {
      case FilterChoiceId.NEW:
        setState(() {
          _currentFilterChoice = choices[0];
          _controller.add(FilterChoiceId.NEW);
        });
        break;
      case FilterChoiceId.HOT:
        setState(() {
          _currentFilterChoice = choices[1];
          _controller.add(FilterChoiceId.HOT);
        });
        break;
      case FilterChoiceId.MY_VOTES:
        setState(() {
          _currentFilterChoice = choices[2];
          _controller.add(FilterChoiceId.MY_VOTES);
        });
        break;
      case FilterChoiceId.MY_POOLS:
        setState(() {
          _currentFilterChoice = choices[3];
          _controller.add(FilterChoiceId.MY_POOLS);
        });
        break;

      case FilterChoiceId.CLOSE:
        try{
          if(await context.read<PoolProvider>().getPosition() != null){
            setState(() {
              _currentFilterChoice = choices[4];
              _controller.add(FilterChoiceId.CLOSE);
            });
            break;
          }else{
            const snackBar = SnackBar(
              content: Text('Unable to get location'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }catch(e){
          const snackBar = SnackBar(
            content: Text('Unable to get location'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
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
      title: 'Hot', icon: Icons.whatshot, filterChoiceId: FilterChoiceId.HOT),
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

enum FilterChoiceId { NEW, HOT, MY_VOTES, MY_POOLS, CLOSE}
