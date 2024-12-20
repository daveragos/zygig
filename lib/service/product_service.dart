import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zygig/model/product.dart';

class ProductService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProducts() {
    return products.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
}