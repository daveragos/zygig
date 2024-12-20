import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zygig/screen/account_page.dart';
import 'package:zygig/screen/poduct_page.dart';
import 'package:zygig/screen/wishlist_listing_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String user = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!.email!;
  }

  final List<Widget> _widgetOptions = <Widget>[
    WishlistListingPage(),
    ProductListingPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back, $user'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.amber[800]!,
        items: const <Widget>[
          Icon(Icons.favorite, size: 30),
          Icon(Icons.shopping_bag_outlined, size: 30),
          Icon(Icons.person, size: 30),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
