import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/aboutRestPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_app/loginPage.dart';
import 'package:the_app/main.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/Product.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  MyApp myApp = MyApp();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  void fetchData() {
    firebaseManager.fetchData((productList) {
      if (productList != null) {
        setState(() {
          products = productList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "The Shop",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            children: [
              Text(
                "Search Bar",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: (200 / 320),
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: double.infinity,
                            child: Image.network(
                              products[index].image,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            products[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            products[index].description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "${products[index].price}",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                firebaseManager.addToShoppingCart(products[index], (wasTrue, error) {
                                  if(!wasTrue && error != null) {
                                    _showMyDialog(context, error);
                                  }
                                });
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(150, 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          )),
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