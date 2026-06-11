import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../models/category.dart';
import '../utils/theme_utils.dart';
import 'product_details_screen.dart';
import 'category_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ProductProvider>().initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final filteredProducts = query.isEmpty
            ? provider.products
            : provider.products
                .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
                .toList();

        // Extract unique categories dynamically
        final uniqueCategoryStrings = provider.products.map((p) => p.category).toSet().toList();
        final List<Category> categories = uniqueCategoryStrings.map((catStr) {
          return Category(
            id: catStr,
            name: catStr.toUpperCase(),
            icon: getCategoryIcon(catStr),
            color: getCategoryColor(catStr),
          );
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F8),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Header
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 32),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFF8B5CF6),
                              Color(0xFFa78bfa),
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x556C63FF),
                              blurRadius: 30,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.storefront_rounded, color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'سوقي',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 22,
                                    child: Icon(Icons.person_rounded, color: Colors.white, size: 22),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'مرحباً بك 👋',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'اكتشف أحدث المنتجات',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) => setState(() => query = val),
                                decoration: InputDecoration(
                                  hintText: 'ابحث عن منتج...',
                                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                  border: InputBorder.none,
                                  icon: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                                    ).createShader(bounds),
                                    child: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (provider.offlineMode)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.wifi_off_rounded, color: Colors.orange),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "وضع عدم الاتصال - البيانات معروضة من التخزين",
                                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Categories
                      if (categories.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                          child: Column(
                            children: [
                              const SectionHeader(title: 'تصفح الأقسام'),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 115,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                                  itemBuilder: (context, index) {
                                    final cat = categories[index];
                                    final count = provider.products.where((p) => p.category == cat.id).length;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CategoryProductsScreen(category: cat),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              gradient: getGradient(cat.color),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: getColor(cat.color).withOpacity(0.35),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(cat.icon, style: const TextStyle(fontSize: 30)),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            cat.name,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2D3142)),
                                          ),
                                          Text(
                                            '$count منتج',
                                            style: TextStyle(fontSize: 9, color: Colors.grey[400]),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Promo Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B6B).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: -20,
                                top: -20,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                bottom: -10,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text('🔥 عرض محدود', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('تخفيضات كبرى', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.1)),
                                  const SizedBox(height: 4),
                                  const Text('على جميع الأقسام', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Products Grid
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          children: [
                            const SectionHeader(title: 'منتجات مختارة لك'),
                            const SizedBox(height: 4),
                            if (filteredProducts.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Text('لا توجد منتجات', style: TextStyle(color: Colors.grey[500])),
                                ),
                              )
                            else
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailsScreen(product: product),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

