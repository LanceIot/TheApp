import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/controllers/orderPage.dart';
import 'package:the_app/managers/firebaseManager.dart';
import 'package:the_app/models/OrderModel.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirebaseManager firebaseManager = FirebaseManager.getInstance();
  final List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    firebaseManager.initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("orders")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "Empty orders",
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data!.docs[index].id),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("orders")
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: Colors.purpleAccent,
                          ),
                        ),
                        title: Text(snapshot.data!.docs[index].get('address')),
                        trailing: ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("orders")
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 100,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(
                      totalPrice: 1255600,
                    ),
                  ),
                );
                // Uncomment the following code if you want to use firebaseManager.fetchShopCartProducts
                /*
                firebaseManager.fetchShopCartProducts((products) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(shopCartProducts: products),
                    ),
                  );
                });
                */
              },
              child: Text(
                "Order",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purpleAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
