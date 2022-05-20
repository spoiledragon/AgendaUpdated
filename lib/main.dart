// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:agendapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      title: 'Email and Password Login',
      theme: ThemeData(

        primarySwatch: Colors.amber,
      ),
      home: LoginScreen(),
    );
  }
}




