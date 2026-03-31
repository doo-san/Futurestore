class Product {
  int id;
  String? title;
  String? price;
  int? quantity;
  String? image;
  String? description;

  Product({
    required this.id,
    this.title,
    this.price,
    this.quantity,
    this.image,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price']?.toString(),
      quantity: json['current_stock'],
      image: json['image'],
      description: json['description'],
    );
  }
}



