import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/page_header.dart';
import '../utils/theme_utils.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final favProducts = provider.favorites;

        return Column(
          children: [
            PageHeader(title: 'المفضلة', subtitle: '${favProducts.length} منتجات محفوظة'),
            Expanded(
              child: favProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B).withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.favorite_outline_rounded, size: 80, color: const Color(0xFFFF6B6B).withOpacity(0.5)),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'قائمة المفضلة فارغة',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'احفظ منتجاتك المفضلة هنا للعودة إليها لاحقاً',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: favProducts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final p = favProducts[index];
                        final categoryColor = getCategoryColor(p.category);
                        
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(product: p),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    gradient: getLightGradient(categoryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      p.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF2D3142)),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${p.price} ر.س',
                                        style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w900, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => provider.toggleFavorite(p),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B6B).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.favorite_rounded, color: Color(0xFFFF6B6B), size: 24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

