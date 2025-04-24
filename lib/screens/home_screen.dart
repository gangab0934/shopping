import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_grid.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [
    Product(id: '1', title: 'T-Shirt', price: 30, imageUrl: 'https://cdn.pixabay.com/photo/2024/02/06/18/10/ai-generated-8557635_1280.jpg', category: 'Clothing'),
    Product(id: '2', title: 'Sneakers', price: 70, imageUrl: 'https://i.redd.it/chc3dit71cu01.jpg', category: 'Footwear'),
    Product(id: '3', title: 'Jeans', price: 50, imageUrl: 'https://images.pexels.com/photos/4109759/pexels-photo-4109759.jpeg?cs=srgb&dl=pexels-castorly-stock-4109759.jpg&fm=jpg', category: 'Clothing'),
    Product(id: '4', title: 'Watch', price: 150, imageUrl: 'https://images.pexels.com/photos/3766111/pexels-photo-3766111.jpeg?cs=srgb&dl=photo-of-analog-sapphire-wrist-watch-3766111.jpg&fm=jpg', category: 'Accessories'),
  ];

  Map<String, CartItem> _cartItems = {};

  void _addToCart(Product product) {
    setState(() {
      if (_cartItems.containsKey(product.id)) {
        _cartItems.update(
          product.id,
              (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            quantity: existing.quantity + 1,
            price: existing.price,
          ),
        );
      } else {
        _cartItems.putIfAbsent(
          product.id,
              () => CartItem(
            id: product.id,
            title: product.title,
            quantity: 1,
            price: product.price,
          ),
        );
      }
    });
  }

  int get _cartItemCount {
    return _cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("🛍️ My Shop", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CartScreen(_cartItems),
                  ));
                },
              ),
              if (_cartItemCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$_cartItemCount',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            // Search Field (Optional)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {},
            ),
            SizedBox(height: 12),
            // Product Grid
            Expanded(
              child: ProductGrid(
                products: _products,
                onAddToCart: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}