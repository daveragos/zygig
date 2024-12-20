import 'package:flutter/material.dart';

class ProductListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 10, // Replace with fetched product count
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Placeholder(fallbackHeight: 100),
                Text('Product Name'),
                Text('\$Price'),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle wishlist logic
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
