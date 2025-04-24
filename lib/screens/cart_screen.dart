import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final Map<String, CartItem> cartItems;

  CartScreen(this.cartItems);

  double get totalAmount {
    return cartItems.values.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('No items in your cart!'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems.values.toList()[i];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('x${item.quantity}'),
                  trailing: Text('\$${item.price * item.quantity}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
