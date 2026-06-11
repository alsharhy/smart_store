import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/theme_utils.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(product.category);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final isFavorite = provider.isFavorite(product.id);

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Section
                    Container(
                      height: 420,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            getColor(categoryColor, shade: 100),
                            getColor(categoryColor, shade: 50),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Decorative circles
                          Positioned(
                            right: -40,
                            top: 60,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColor(categoryColor).withOpacity(0.08),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            bottom: 40,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getColor(categoryColor).withOpacity(0.06),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Hero(
                              tag: 'product_${product.id}',
                              child: product.image.isNotEmpty
                                  ? Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
                                    )
                                  : const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Details Section
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 20,
                              offset: Offset(0, -8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        getColor(categoryColor).withOpacity(0.15),
                                        getColor(categoryColor).withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    product.category.toUpperCase(),
                                    style: TextStyle(color: getColor(categoryColor), fontWeight: FontWeight.w700, fontSize: 12),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${product.price} ر.س',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              product.title,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFFFA726), size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    product.rating.rate.toStringAsFixed(1),
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFF57C00), fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 16, color: const Color(0xFFFFCC80)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${product.rating.count} مراجعة',
                                    style: const TextStyle(color: Color(0xFFF57C00), fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Row(
                              children: [
                                Icon(Icons.description_outlined, color: Color(0xFF6C63FF), size: 20),
                                SizedBox(width: 8),
                                Text('الوصف التفصيلي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF2D3142))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.description,
                              style: const TextStyle(color: Color(0xFF9CA3AF), height: 1.8, fontSize: 14),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Top Navigation Bar
              Positioned(
                top: 44,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildTopButton(
                      icon: Icons.share_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.toggleFavorite(product),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: isFavorite
                                ? const LinearGradient(colors: [Color(0xFFFFE0E0), Color(0xFFFFCDD2)])
                                : null,
                            color: isFavorite ? null : const Color(0xFFF0F2F8),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isFavorite ? const Color(0xFFFF6B6B) : const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: isFavorite ? const Color(0xFFFF6B6B) : const Color(0xFFB0B5C9),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            provider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('تم إضافة المنتج إلى السلة'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xFF6C63FF),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withOpacity(0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'إضافة إلى السلة',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF2D3142), size: 22),
      ),
    );
  }
}
