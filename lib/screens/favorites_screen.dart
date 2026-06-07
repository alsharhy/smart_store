import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),

      body: Consumer<ProductProvider>(
        builder: (_, provider, __) {
          return ListView.builder(
            itemCount: provider.favorites.length,

            itemBuilder: (_, index) {
              return ProductCard(product: provider.favorites[index]);
            },
          );
        },
      ),
    );
  }
}
