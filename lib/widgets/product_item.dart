import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductItem({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${product.price}', style: TextStyle(color: Colors.green)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onAddToCart,
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
