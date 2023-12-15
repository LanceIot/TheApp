import 'package:flutter/material.dart';
import 'package:the_app/managers/firebaseManager.dart';
import 'package:the_app/models/UserModel.dart';
import 'package:the_app/userPage.dart';

class UserInfoPage extends StatefulWidget {
  UserModel user;

  UserInfoPage({required this.user});

  @override
  _ProfileEditWidgetState createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<UserInfoPage> {
  String name = "";
  String lastname = "";

  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController lastnameController;

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.user.email);
    nameController = TextEditingController(text: widget.user.name);
    lastnameController = TextEditingController(text: widget.user.lastname);
    name = widget.user.name;
    lastname = widget.user.lastname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              readOnly: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                name = value;
              },
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                lastname = value;
              },
              controller: lastnameController,
              decoration: InputDecoration(labelText: 'Lastname'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (name != widget.user.name ||
                    lastname != widget.user.lastname) {
                  if (name != "" || lastname != "") {
                    await firebaseManager.updateUserData(name, lastname);
                  }

                  firebaseManager.fetchUserData((myUser) {
                    if (myUser != null) {
                      setState(() {
                        widget.user = myUser;
                      });
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                elevation: 5,
              ),
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print('Save Button Pressed');
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
