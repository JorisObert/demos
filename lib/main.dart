
import 'dart:async';

import 'package:demos/providers/demos_user_provider.dart';
import 'package:demos/providers/pool_provider.dart';
import 'package:demos/screens/splash/splash_screen.dart';
import 'package:demos/theme/style.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      // The following lines are the same as previously explained in "Handling uncaught errors"
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(MyApp());
    }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Text('error'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
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

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
