import 'package:flutter/material.dart';

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
          Switch(
            value: _isGridView,
            onChanged: (value) {
              setState(() {
                _isGridView = value;
              });
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView() : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
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
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: 10, // Replace with fetched product count
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: SizedBox(
              height: 50,
              width: 50,
              child: Placeholder(fallbackHeight: 50, fallbackWidth: 50)),
            title: Text('Product Name'),
            subtitle: Text('\$Price'),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // Handle wishlist logic
              },
            ),
          ),
        );
      },
    );
  }
}
