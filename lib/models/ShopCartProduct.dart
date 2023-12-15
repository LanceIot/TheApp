import 'package:the_app/models/Product.dart';

class ShopCartProduct extends Product {
  int productCount;

  ShopCartProduct({
    required String id,
    required String name,
    required String image,
    required String description,
    required int price,
    required List<String> tags,
    required this.productCount,
  }) : super(
          id: id,
          name: name,
          image: image,
          description: description,
          price: price,
          tags: tags,
        );
}
