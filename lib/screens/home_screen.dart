import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),

      body: Consumer<ProductProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              if (provider.offlineMode)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Offline Mode",
                    textAlign: TextAlign.center,
                  ),
                ),

              Expanded(
                child: ListView.builder(
                  itemCount: provider.products.length,

                  itemBuilder: (_, index) {
                    return ProductCard(product: provider.products[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
