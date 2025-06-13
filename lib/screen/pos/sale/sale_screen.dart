import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting date/time
import '../../../controller/sale_controller.dart';
import '../../../utils/constants.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final SaleController controller = Get.put(SaleController());

  final TextEditingController _searchController = TextEditingController();

  String _formattedDateTime = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    // Cambodia is UTC+7, so get current UTC time + 7 hours
    final nowUtc = DateTime.now().toUtc();
    final cambodiaTime = nowUtc.add(const Duration(hours: 7));
    final formatted = DateFormat('dd/MM/yyyy  HH:mm:ss').format(cambodiaTime);
    setState(() {
      _formattedDateTime = formatted;
    });
  }

  void _onSearchChanged(String query) {
    controller.filterProductsByName(query);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        backgroundColor: appColor,
        title: SizedBox(
          width: 200,
          height: 40,
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: appColor.withOpacity(0.3),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                _formattedDateTime,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // 🟥 LEFT SIDE
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // 🟦 CATEGORY BUTTONS
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Obx(() {
                        if (controller.loading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.filteredCategories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category =
                                controller.filteredCategories[index];
                            // Only "All" category button is red, others white
                            final isAllCategory =
                                category.name.toLowerCase() == 'all';

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isAllCategory ? Colors.red : Colors.white,
                                foregroundColor:
                                    isAllCategory ? Colors.white : Colors.black,
                                elevation: 0,
                              ).copyWith(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {
                                controller.selectedCategoryId.value =
                                    category.id;
                                controller
                                    .filterProductsByCategory(category.id);
                                // Clear search text when category changes
                                _searchController.clear();
                              },
                              child: Text(category.name),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ),

                // 🟨 PRODUCTS GRID
                Expanded(
                  flex: 9,
                  child: Obx(() {
                    if (controller.loading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.filteredProducts.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 20 / 24,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                        final imageUrl = (product.image != null &&
                                product.image!.isNotEmpty)
                            ? 'http://127.0.0.1:8000/storage/${product.image}'
                            : null;

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              controller.onSubmitPre(); // Add to cart or order
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image with Price Overlay
                                Expanded(
                                  flex: 4,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: imageUrl != null
                                              ? Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                          Icons.broken_image,
                                                          size: 32),
                                                )
                                              : const Icon(
                                                  Icons.image_not_supported,
                                                  size: 32),
                                        ),
                                      ),

                                      // Price Overlay
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Product Info
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.name,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                // 🟩 FOOTER PAY BUTTON
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.orange,
                    child: const Center(child: Text("Footer / Pay Section")),
                  ),
                ),
              ],
            ),
          ),

          // 🟦 RIGHT SIDE (Order summary)
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.green.shade100,
              child: const Center(child: Text("Order Summary")),
            ),
          ),
        ],
      ),
    );
  }
}
