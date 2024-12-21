import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zygig/model/product.dart';
import 'package:zygig/service/product_service.dart';
import 'package:zygig/service/wishlist_service.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  bool _isGridView = true;

  String user = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back, $user'),
      ),

      // IconButton(
      //   icon: Icon(Icons.favorite),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => WishlistListingPage()),
      //     );
      //   },
      // ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Products', style: TextStyle(fontSize: 20)),
                  InkWell(
                    child:
                        _isGridView ? Icon(Icons.grid_view) : Icon(Icons.list),
                    onTap: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ]),
          ),
          Expanded(
            child: StreamBuilder(
                stream: ProductService().getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || (snapshot.data!.isEmpty)) {
                    return Center(child: Text('There is no product'));
                  }
                  final products = snapshot.data!;
                  return _isGridView
                      ? _buildGridView(products: products)
                      : _buildListView(products: products);
                }),
          ),
        ],
      ),
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
          color: Colors.white,
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
                          return Icon(Icons.favorite_border);
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
                      return Icon(Icons.favorite_border);
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
