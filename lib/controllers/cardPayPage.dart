import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/OrderModel.dart';
import 'package:the_app/models/ShopCartProduct.dart';

class CardPayPage extends StatefulWidget {

  OrderModel orderModel;
  CardPayPage({required this.orderModel});

  @override
  _CardPayPageState createState() => _CardPayPageState();
}

class _CardPayPageState extends State<CardPayPage> {
  FirebaseManager firebaseManager = FirebaseManager.getInstance();
  
  void initState() {
    super.initState();

    widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/card.png'), 
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Card Number',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Month',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Year',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'CVV',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
