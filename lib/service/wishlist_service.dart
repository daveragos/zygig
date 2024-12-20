import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a product to the wishlist
  Future<void> addToWishlist(String productId) async {
    final user = _auth.currentUser;

    if (user != null) {
      final wishlistRef = _firestore.collection('wishlist').doc(user.uid);
      await wishlistRef.set({
        'products': FieldValue.arrayUnion([productId])
      }, SetOptions(merge: true));
    }
  }

  // Remove a product from the wishlist
  Future<void> removeFromWishlist(String productId) async {
    final user = _auth.currentUser;

    if (user != null) {
      final wishlistRef = _firestore.collection('wishlist').doc(user.uid);
      await wishlistRef.update({
        'products': FieldValue.arrayRemove([productId])
      });
    }
  }

  // Check if a product is in the wishlist
  Future<bool> isInWishlist(String productId) async {
    final user = _auth.currentUser;

    if (user != null) {
      final wishlistDoc = await _firestore.collection('wishlist').doc(user.uid).get();
      if (wishlistDoc.exists) {
        final List<dynamic> products = wishlistDoc.data()?['products'] ?? [];
        return products.contains(productId);
      }
    }
    return false;
  }

  // Get the user's wishlist
  Future<List<String>> getWishlistProductIds() async {
    final user = _auth.currentUser;

    if (user != null) {
      final wishlistDoc = await _firestore.collection('wishlist').doc(user.uid).get();
      if (wishlistDoc.exists) {
        return List<String>.from(wishlistDoc.data()?['products'] ?? []);
      }
    }
    return [];
  }
}
