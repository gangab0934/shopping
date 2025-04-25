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
    Product(id: '3', title: 'Jeans', price: 50, imageUrl: 'https://images.pexels.com/photos/4109759/pexels-photo-4109759.jpeg', category: 'Clothing'),
    Product(id: '4', title: 'Watch', price: 150, imageUrl: 'https://images.pexels.com/photos/3766111/pexels-photo-3766111.jpeg', category: 'Accessories'),
  ];

  List<Product> _filteredProducts = [];
  Map<String, CartItem> _cartItems = {};
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Price (Low to High)';

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products; // Initialize with all products
  }

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

  void _sortProducts(String? sortBy) {
    setState(() {
      if (sortBy == null) return;
      _sortBy = sortBy;
      if (sortBy == 'Price (Low to High)') {
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == 'Price (High to Low)') {
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      } else if (sortBy == 'Name') {
        _filteredProducts.sort((a, b) => a.title.compareTo(b.title));
      }
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      if (category == null) return;
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) => product.category == category).toList();
      }
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
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
            // Search Field
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
              onChanged: _searchProducts,
            ),
            SizedBox(height: 12),
            // Sort and Filter Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _sortBy,
                  onChanged: _sortProducts,
                  items: <String>[
                    'Price (Low to High)',
                    'Price (High to Low)',
                    'Name',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: _filterByCategory,
                  items: <String>['All', 'Clothing', 'Footwear', 'Accessories']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Product Grid
            Expanded(
              child: ProductGrid(
                products: _filteredProducts,
                onAddToCart: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
