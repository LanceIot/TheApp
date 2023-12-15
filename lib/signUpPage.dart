import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/homePage.dart';
import 'package:the_app/loginPage.dart';
import 'package:the_app/mainScreen.dart';
import 'package:the_app/managers/firebaseManager.dart';
import 'package:the_app/main.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  FirebaseManager firebaseManager = FirebaseManager.getInstance();
  MyApp myApp = new MyApp();

  String nameText = "";
  String lastnameText = "";
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
                  "Sign Up Page",
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
              const SizedBox(height: 16.0),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  nameText = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  lastnameText = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Lastname',
                ),
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
                  firebaseManager.signUp(nameText, lastnameText, emailText, passwordText, (wasCreated, error) {
                    if (wasCreated && error == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                    } else {
                      _showMyDialog(context, error!);
                    }
                  });
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 8.0),
              const Text("Already have an account?"),
              TextButton(onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
              }, child: const Text("Log In"))
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
