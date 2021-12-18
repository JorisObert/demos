import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer();

  @override
  createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Column(
              children: <Widget>[],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: Text('Home'),
            onTap: () {
              navigationPage("/MainScreen");
            },
          ),
        ],
      ),
    );
  }

  void navigationPage(String route) {
    if (ModalRoute.of(context)?.settings.name == route) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }
}
