import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_app/cardPage.dart';
import 'package:the_app/controllers/ordersPage.dart';
import 'package:the_app/loginPage.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/UserModel.dart';
import 'package:the_app/UserInfoPage.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel? user = null;

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() {
    firebaseManager.fetchUserData((user) {
      if (user != null) {
        setState(() {
          this.user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          GestureDetector(
            onTap: () {
              if (user != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                          user: user!,
                        )));
              } else {
                _showMyDialog(context);
              }
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.person,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    user?.name ?? "Loading",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()),
              );
            },
            child: SizedBox(
              height: 10,
            ),
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.shop_two,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CardPage()));
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.credit_card,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Cards",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              firebaseManager.signOut((isTrue, error) {
                if (isTrue && error == null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  print("Something get wrong with sign out");
                }
              });
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ooops!'),
        content: Text('Sorry, something get wrong'),
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
