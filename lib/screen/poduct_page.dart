import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zygig/model/product.dart';
import 'package:zygig/screen/wishlist_listing_page.dart';
import 'package:zygig/service/wishlist_service.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
  InkWell(
    child: _isGridView ? Icon(Icons.grid_view) : Icon(Icons.list),
    onTap: () {
      setState(() {
        _isGridView = !_isGridView;
      });
    },
  ),
  IconButton(
    icon: Icon(Icons.favorite),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WishlistListingPage()),
      );
    },
  ),
  SizedBox(width: 25,)
],

      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('products').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text('There is no product'));
            }
            final data = snapshot.data;
            final products =
                data!.docs.map((doc) => Product.fromFirestore(doc)).toList();
            return _isGridView
                ? _buildGridView(products: products)
                : _buildListView(products: products);
          }),
    );
  }

  Widget _buildGridView({required List<Product> products}) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: products.length,
      itemBuilder: (context, index) {

        final prod = products[index];
        return Card(
          child: Column(
            children: [
              Image.network(
                prod.imageUrl,
                width: 150,
                height: 150,
                fit: BoxFit.contain,

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(prod.name),
                      Text(prod.price.toString()),
                    ],
                  ),
                  IconButton(
                    icon: FutureBuilder(
                      future: WishlistService().isInWishlist(prod.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Icon(
                              Icons.favorite_border);
                        }
                        final isFavorite = snapshot.data ?? false;
                        return Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        );
                      },
                    ),
                    onPressed: () async {
                      final isFavorite =
                          await WishlistService().isInWishlist(prod.id);
                      if (isFavorite) {
                        await WishlistService().removeFromWishlist(prod.id);
                      } else {
                        await WishlistService().addToWishlist(prod.id);
                      }
                      setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView({required List<Product> products}) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return Card(
          child: ListTile(
              leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    prod.imageUrl,

                  )),
              title: Text(prod.name),
              subtitle: Text(prod.price.toString()),
              trailing: IconButton(
                icon: FutureBuilder(
                  future: WishlistService().isInWishlist(prod.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Icon(
                          Icons.favorite_border);
                    }
                    final isFavorite = snapshot.data ?? false;
                    return Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    );
                  },
                ),
                onPressed: () async {
                  final isFavorite =
                      await WishlistService().isInWishlist(prod.id);
                  if (isFavorite) {
                    await WishlistService().removeFromWishlist(prod.id);
                  } else {
                    await WishlistService().addToWishlist(prod.id);
                  }
                  setState(() {});
                },
              )),
        );
      },
    );
  }
}
