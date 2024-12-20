import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zygig/model/product.dart';
import 'package:zygig/service/wishlist_service.dart';

class WishlistListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
        future: WishlistService().getWishlistProductIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No items in wishlist'));
          }
          final productIds = snapshot.data as List<String>;

          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('products')
                .where(FieldPath.documentId, whereIn: productIds)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No items in wishlist'));
              }
              final products = snapshot.data!.docs.map((doc) {
                return Product.fromFirestore(doc);
              }).toList();

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await WishlistService().removeFromWishlist(product.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
