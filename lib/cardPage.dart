import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/CardModel.dart';

class CardPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CardPage> {
  FirebaseManager firebaseManager = FirebaseManager.getInstance();
  int indexOfCard = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Cards'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("cards")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("Empty cards"),
                  );
                }

                indexOfCard = snapshot.data!.docs.length;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showEditCardDialog(context, index, firebaseManager);
                      },
                      onLongPress: () {
                        _showDeleteCardDialog(context, snapshot, index);
                      },
                      child: Card(
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            color: _generateRandomColor(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.only(left: 50, right: 50, top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Card ${index + 1}'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index].get("cardNumber")}',
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${snapshot.data!.docs[index].get("month")}/${snapshot.data!.docs[index].get("year")}'),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        'CCV: ${snapshot.data!.docs[index].get("ccv")}'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCardDialog(context, indexOfCard);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showAddCardDialog(BuildContext context, int indx) {
    int index = indx+1;
    String number = "";
    String month = "";
    String year = "";
    String ccv = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Card"),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Card Number"),
                onChanged: (value) => number = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Expiration Month"),
                onChanged: (value) => month = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Expiration Year"),
                onChanged: (value) => year = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "CCV"),
                onChanged: (value) => ccv = value,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (number.isNotEmpty &&
                    month.isNotEmpty &&
                    year.isNotEmpty &&
                    ccv.isNotEmpty) {
                  firebaseManager.addCardInfo(
                    CardModel(
                      id: index,
                      number: number,
                      month: month,
                      year: year,
                      ccv: ccv,
                    ),
                    (isTrue, error) {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.greenAccent),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
            )
          ],
        );
      },
    );
  }

  _showEditCardDialog(
      BuildContext context, int index, FirebaseManager firebaseManager) {
    String number = "";
    String month = "";
    String year = "";
    String ccv = "";

    firebaseManager.fetchCardInfo(index, (cardInfo) {
      if (cardInfo != null) {
        number = cardInfo.number;
        month = cardInfo.month;
        year = cardInfo.year;
        ccv = cardInfo.ccv;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Edit Card"),
              content: Column(
                children: [
                  Text('Card ${index + 1}'),
                  TextField(
                    decoration: InputDecoration(labelText: "Card Number"),
                    controller: TextEditingController(text: number),
                    onChanged: (value) => number = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Expiration Month"),
                    controller: TextEditingController(text: month),
                    onChanged: (value) => month = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Expiration Year"),
                    controller: TextEditingController(text: year),
                    onChanged: (value) => year = value,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "CCV"),
                    controller: TextEditingController(text: ccv),
                    onChanged: (value) => ccv = value,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (number.isNotEmpty &&
                        month.isNotEmpty &&
                        year.isNotEmpty &&
                        ccv.isNotEmpty) {
                      firebaseManager.updateCardData(
                          index, number, month, year, ccv);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.greenAccent),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey),
                  ),
                )
              ],
            );
          },
        );
      }
    });
  }

  _showDeleteCardDialog(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("Want to delete?"),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("cards")
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      200 + random.nextInt(56),
      200 + random.nextInt(56),
      200 + random.nextInt(56),
      1.0,
    );
  }
}
