class Product {
  String id;
  String name;
  String image;
  String description;
  int price;
  List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.tags,
  });
}