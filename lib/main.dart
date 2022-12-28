
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UI/auth/login_screen.dart';

Future<void> main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Do Chat',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 1,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            titleTextStyle:TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 19),
          ),
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen()
    );
  }
}

