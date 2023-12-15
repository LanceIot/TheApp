import 'package:the_app/models/ShopCartProduct.dart';

class OrderModel {
  String adress;
  List<ShopCartProduct> shopCartProducts;
  String paymentWay;
  int totalPrice;

  OrderModel({
    required this.adress,
    required this.shopCartProducts,
    required this.paymentWay,
    required this.totalPrice,
  });
}
