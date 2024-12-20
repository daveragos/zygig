import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, this.imageUrl = ''});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}