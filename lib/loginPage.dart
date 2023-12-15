import 'package:flutter/material.dart';
import 'package:the_app/homePage.dart';
import 'package:the_app/main.dart';
import 'package:the_app/mainScreen.dart';
import 'package:the_app/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_app/managers/firebaseManager.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  FirebaseManager firebaseManager = FirebaseManager.getInstance();
  MyApp myApp = new MyApp();

  String emailText = "";
  String passwordText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Login Page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  emailText = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  passwordText = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  firebaseManager.signIn(emailText, passwordText, (wasTrue, error) {
                    if(wasTrue && error == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                    } else {
                      _showMyDialog(context, error!);
                    }
                  });
                },
                child: const Text('Log In'),
              ),
              const SizedBox(height: 8.0),
              const Text("Don't have an account yet?"),
              TextButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
              }, child: const Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, FirebaseAuthException error) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ooops something get wrong!'),
          content: Text('${error.message}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
}