import 'package:demos/screens/login/login_screen.dart';
import 'package:demos/screens/main/components/create_pool_dialog.dart';
import 'package:demos/screens/my_pools/my_pools_screen.dart';
import 'package:demos/screens/pools/pools_screen.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
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
        vsync: this, duration: Duration(milliseconds: 300), animationBehavior: AnimationBehavior.preserve);
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.blueGrey.shade900,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.audiotrack),
                Text('Demos'),
              ],
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                     if(_panelController.isPanelOpen){
                        _animationController.animateBack(0.0);
                        _panelController.close();
                      }else{
                        _animationController.forward(from: 0.0);
                        _panelController.open();
                      }
                      /*if(_loginPanelController.isPanelOpen){
                        _animationController.animateBack(0.0);
                        _loginPanelController.close();
                      }else{
                        _animationController.forward(from: 0.0);
                        _loginPanelController.open();
                      }*/
                    },
                    child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.125)
                          .animate(_animationController),
                      child: Icon(
                        Icons.add,
                        size: 26.0,
                      ),

                    ),
                  )
              ),
            ],
          ),

          body: Stack(
            children: [
              TabBarView(
                children: [
                  PoolsScreen(),
                  MyPoolsScreen(),
                  Container(),
                  Container(),
                ],
                controller: _myTabController,
              ),
              _createVotePanel(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _pageIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) async {
              this._myTabController.animateTo(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              )
            ],
          ),
        ),
        _loginPanel(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget _createVotePanel() {
    return SlidingUpPanel(
      controller: _panelController,
color: Colors.blueGrey.shade900,
isDraggable: false,
      panel: CreatePoolDialog(
        onClosed: () => _panelController.close(),
      ),
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height
          -AppBar().preferredSize.height
          -kBottomNavigationBarHeight-MediaQuery.of(context).padding.top
          -MediaQuery.of(context).padding.bottom,
    );
  }

  Widget _loginPanel() {
    return SlidingUpPanel(
      controller: _loginPanelController,
      isDraggable: false,
      panel: LoginScreen(
        onClosed: () => _loginPanelController.close(),
      ),
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height
    );
  }
}
