import 'package:flutter/material.dart';
import 'package:the_app/homePage.dart';
import 'package:the_app/loginPage.dart';
import 'package:the_app/managers/firebaseManager.dart';

class WidgetTree extends StatefulWidget {
  WidgetTree({Key? key}) : super(key: key);

  

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseManager.authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}