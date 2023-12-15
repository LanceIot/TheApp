import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/OrderModel.dart';
import 'package:the_app/models/ShopCartProduct.dart';

class OrderPage extends StatefulWidget {
  final int totalPrice;

  OrderPage({required this.totalPrice});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  FirebaseManager firebaseManager = FirebaseManager.getInstance();

  List<ShopCartProduct> shopCartProducts = [];

  TextEditingController addressController = TextEditingController();
  bool payWithCash = false;
  bool payWithCard = false;
  int totalPrice = 0;

  void initState() {
    super.initState();

    widget.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Address:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            AddressTextField(controller: addressController),
            SizedBox(height: 16),
            Text(
              'Payment Options:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: payWithCash,
                  onChanged: (value) {
                    setState(() {
                      payWithCash = value ?? false;
                      if (payWithCash) {
                        payWithCard = false;
                      }
                    });
                  },
                ),
                Text('Pay with Cash'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: payWithCard,
                  onChanged: (value) {
                    setState(() {
                      payWithCard = value ?? false;
                      if (payWithCard) {
                        payWithCash = false;
                      }
                    });
                  },
                ),
                Text('Pay with Card'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Address: ${addressController.text}');
                print('Pay with Cash: $payWithCash');
                print('Pay with Card: $payWithCard');

                // for(int i = 0; i < shopCartProducts.length; i++) {
                //   totalPrice += shopCartProducts[i].price * shopCartProducts[i].productCount;
                //   print(shopCartProducts[i].price);
                // }
 

                if(payWithCash) {
                  OrderModel orderModel = OrderModel(adress: addressController.text, shopCartProducts: shopCartProducts, paymentWay: "Cash", totalPrice: widget.totalPrice);

                  firebaseManager.addOrder(orderModel, (isCreated, error) {
                    if (isCreated && error == null) {
                      _showMyDialog(context);
                    }
                  });
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;

  AddressTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter your address',
        border: OutlineInputBorder(),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text('Order created'),
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