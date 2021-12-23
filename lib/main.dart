import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/splash/splash_screen.dart';
import 'package:demos/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.reflectable.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initializeReflectable();
    Backendless.initApp(
        applicationId: '672BED33-750C-2C85-FF7E-BBEE4DC62300',
        androidApiKey: '82938B91-1244-4FA8-AD66-E2A595D339C2',
        iosApiKey: '47B234E3-362C-4D64-981D-462EA1A70599');
  }

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
            providers: [
              ChangeNotifierProvider<PoolProvider>(create: (_) => PoolProvider()),
              ChangeNotifierProvider<DemosUserProvider>(create: (_) => DemosUserProvider()),
            ],
            child: MaterialApp(
              home: SplashScreen(),
              theme: appTheme(),
            ),
          );
  }
}
