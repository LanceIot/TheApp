import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_app/controllers/orderPage.dart';
import 'package:the_app/managers/firebaseManager.dart';
import 'package:the_app/models/ShopCartProduct.dart';

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  List<ShopCartProduct> shopCartProducts = [];

  int totalPrice = 0;

  @override
  void initState() {
    super.initState();

    firebaseManager.initFirebase();
  }

  Future<void> _updateItemCount(String documentId, int change) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("shopCartProducts")
              .doc(documentId),
        );

        int currentCount = snapshot.get('productCount') ?? 0;
        int newCount = currentCount + change;

        transaction.update(
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("shopCartProducts")
              .doc(documentId),
          {'productCount': newCount},
        );
      });
    } catch (e) {
      print("Error updating productCount: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Shop Cart',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("shopCartProducts")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: Text(
                    "Empty Shop Cart",
                    style: TextStyle(fontSize: 24),
                  ));
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
                            .collection("shopCartProducts")
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
                            child: Image.network(
                              snapshot.data!.docs[index].get("image") ??
                                  "https://coreproduct.brushyourideas.com/static/frontend/Brushyourideas/BYICardTheme/en_US/Mageplaza_Blog/media/images/mageplaza-logo-default.png",
                            ),
                          ),
                          title: Text(snapshot.data!.docs[index].get('name')),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () async {
                                  await _updateItemCount(
                                    snapshot.data!.docs[index].id,
                                    -1,
                                  );
                                },
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("shopCartProducts")
                                    .doc(snapshot.data!.docs[index].id)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    var itemCount =
                                        snapshot.data!.get('productCount') ?? 0;
                                    return Text('$itemCount');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  await _updateItemCount(
                                    snapshot.data!.docs[index].id,
                                    1,
                                  );
                                },
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("shopCartProducts")
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
                            )),
                  );

                  // firebaseManager.fetchShopCartProducts((products) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               OrderPage(shopCartProducts: products)),
                  //     );
                  // });
                },
                child: Text(
                  "Order",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purpleAccent),
                ),
              ),
            ),
          ],
        ));
  }
}
/*
  Future<void> _showAddItemDialog(BuildContext context) async {
    String newItem = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter item',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('items')
                    .add({'item': newItem, 'itemCount': 0});
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
*/