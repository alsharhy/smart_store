import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Card(
      margin: const EdgeInsets.all(10),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(child: Image.network(product.image, height: 150)),

            const SizedBox(height: 10),

            Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),

            const SizedBox(height: 8),

            Text(product.category),

            const SizedBox(height: 8),

            Text("\$${product.price}"),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.star),

                Text(product.rating.rate.toString()),

                const Spacer(),

                IconButton(
                  onPressed: () {
                    provider.toggleFavorite(product);
                  },

                  icon: Icon(
                    provider.isFavorite(product.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
