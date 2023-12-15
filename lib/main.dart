import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/controllers/mainscreen_provider.dart';
import 'package:the_app/homePage.dart';
import 'package:the_app/loginPage.dart';
import 'package:the_app/mainScreen.dart';
import 'package:the_app/WidgetTree.dart';
import 'package:provider/provider.dart';
import 'package:the_app/managers/firebaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MainScreenNotifier())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: firebaseManager.auth.currentUser != null ? MainScreen() : LoginPage(),
    );
  }
}
