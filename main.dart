// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
// import 'package:sellers/models/car_wash.dart';
import 'package:sellers/screens/splash_screen.dart';
// import 'package:sellers/themes/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ignore: unused_local_variable
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
    MyApp(),
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => CarWash()),
    //     ChangeNotifierProvider(create: (_) => ThemeProvider()),
    //   ],
    //   child: MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: "Sellers Apps",
      debugShowCheckedModeBanner: false,
      // theme: themeProvider.themeData,
      home: SplashScreen(),
    );
  }
}
