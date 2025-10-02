import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/sale_controller.dart';
import '../../../controller/table_controller.dart';
import '../../../utils/constants.dart';
import '../../../models/api/category_model.dart' as category_model;
import '../../../models/api/product_model.dart' as product_model;

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final SaleController saleController = Get.find<SaleController>();
  final TableController tableController = Get.find<TableController>();
  final _searchController = TextEditingController();
  String _formattedDateTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initDateTime();
    _setupSearchListener();
    _getTableInfo();
  }

  void _getTableInfo() {
    final arguments = Get.arguments;
    if (arguments != null) {
      final tableId = arguments['table_id'];
      final tableName = arguments['table_name'];

      // Set table in both controllers
      tableController.selectTable(tableId, tableName);
      saleController.setCurrentTable(tableId, tableName);

      print('Table set in sale screen: $tableId, $tableName');
    } else {
      // If no arguments, check if we have table data in controllers
      if (tableController.selectedTableId.value > 0) {
        print(
            'Using table from controller: ${tableController.selectedTableName.value}');
      } else {
        _showSnackbar('Error', 'No table selected');
        Future.delayed(const Duration(seconds: 1), () => Get.back());
      }
    }
  }

  void _initDateTime() {
    _updateDateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateDateTime());
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      saleController.filterProductsByName(_searchController.text);
    });
  }

  void _updateDateTime() {
    final nowUtc = DateTime.now().toUtc();
    final cambodiaTime = nowUtc.add(const Duration(hours: 7));
    setState(() {
      _formattedDateTime =
          DateFormat('dd/MM/yyyy  HH:mm:ss').format(cambodiaTime);
    });
  }

  // Safe snackbar method to avoid GetX errors
  void _showSnackbar(String title, String message) {
    try {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error showing snackbar: $e');
    }
  }

  Future<void> _refreshData() async {
    print('🔄 Refreshing products and categories...');

    saleController.loading.value = true;

    try {
      await Future.wait([
        saleController.fetchProducts(),
        saleController.fetchCategories(),
      ]);

      _searchController.clear();
      saleController.clearSearch();

      print('✅ Products and categories refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing data: $e');
      _showSnackbar('Error', 'Failed to refresh data: ${e.toString()}');
    } finally {
      saleController.loading.value = false;
    }
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
      appBar: _buildAppBar(),
      body: Row(
        children: [
          _buildProductGrid(),
          _buildCartPanel(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: appColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Table: ${tableController.selectedTableName.value.isNotEmpty ? tableController.selectedTableName.value : 'No Table'}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 444),
          Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white54),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  saleController.filterProductsByName(value);
                  setState(() {});
                },
                style: const TextStyle(
                    color: Colors.white), // Add this line for white input text
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14), // Slightly transparent hint
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              size: 20, color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            saleController.clearSearch();
                            setState(() {}); // Trigger rebuild
                          },
                        )
                      : const Icon(Icons.search, color: Colors.white),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                cursorColor: Colors
                    .white, // Optional: Set cursor color to white for better visibility
              ),
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          tableController.loading.value = false;
          Get.back();
        },
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
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _refreshData,
          tooltip: 'Refresh Products & Categories',
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg_image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  _buildProductsGrid(),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        height: 50,
        child: Obx(() {
          if (saleController.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: saleController.filteredCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = saleController.filteredCategories[index];
              final isSelected =
                  saleController.selectedCategoryId.value == category.id;
              return _buildCategoryButton(category, isSelected);
            },
          );
        }),
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.clear, size: 20),
            label: const Text("Clear Cart"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            onPressed: () => saleController.clearCart(),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.discount, size: 20),
            label: const Text("Discount"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              foregroundColor: Colors.white,
            ),
            onPressed: () => _showDiscountDialog(),
          ),
        ],
      ),
    );
  }

  void _showDiscountDialog() {
    final discountType = 'percent'.obs;
    final amountController = TextEditingController(text: '1.00');

    Get.dialog(
      AlertDialog(
        title: const Text('Discount'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Percent (%)'),
                            selected: discountType.value == 'percent',
                            onSelected: (selected) {
                              discountType.value = 'percent';
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Amount (\$)'),
                            selected: discountType.value == 'amount',
                            onSelected: (selected) {
                              discountType.value = 'amount';
                            },
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => TextField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText:
                            discountType.value == 'percent' ? '' : '\$ ',
                        suffixText: discountType.value == 'percent' ? '%' : '',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Safe dialog closing
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }
                        },
                        child: const Text('No'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final value =
                              double.tryParse(amountController.text) ?? 0;

                          // Apply discount first
                          if (discountType.value == 'percent') {
                            saleController.applyPercentDiscount(value);
                          } else {
                            saleController.applyAmountDiscount(value);
                          }

                          // Safe dialog closing
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }
                        },
                        child: const Text('Yes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true, // Allow dismissing by tapping outside
    );
  }

  Widget _buildCategoryButton(
      category_model.Category category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.red : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          saleController.filterProductsByCategory(category.id);
          _searchController.clear();
        },
        child: Text(category.name),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Expanded(
      child: Obx(() {
        if (saleController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (saleController.filteredProducts.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1.10,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: saleController.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = saleController.filteredProducts[index];
              return _buildProductCard(product);
            },
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(product_model.Product product) {
    final imageUrl = (product.image?.isNotEmpty == true)
        ? 'http://127.0.0.1:8000/storage/${product.image}'
        : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => saleController.addProductToCart(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 32),
                            )
                          : const Icon(Icons.image_not_supported, size: 32),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
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
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    if (product.description != null)
                      Text(
                        product.description!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
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
  }

  Widget _buildCartPanel() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Obx(() {
          try {
            if (saleController.cartItems.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                const Text("Current Order", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: ListView.builder(
                    itemCount: saleController.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = saleController.cartItems[index];
                      final key = saleController.getProductKey(product);
                      final quantity = saleController.cartQuantities[key] ?? 1;
                      final total = product.price * quantity;

                      return _buildCartItem(product, quantity, total);
                    },
                  ),
                ),
                _buildCartFooter(),
              ],
            );
          } catch (e) {
            return Center(child: Text('Error loading cart: ${e.toString()}'));
          }
        }),
      ),
    );
  }

  Widget _buildCartItem(
      product_model.Product product, int quantity, double total) {
    final isFree = product.price == 0;
    final priceDisplay =
        isFree ? 'FREE' : '\$${product.price.toStringAsFixed(2)}';
    final totalDisplay = isFree ? 'FREE' : '\$${total.toStringAsFixed(2)}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: product.image != null
            ? Image.network(
                'http://127.0.0.1:8000/storage/${product.image}',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fastfood),
        title: Row(
          children: [
            Text(product.name),
            if (isFree) ...[
              const SizedBox(width: 8),
              const Text('FREE',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$quantity x $priceDisplay'),
            Text(
              totalDisplay,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFree ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
        trailing: _buildCartItemActions(product, quantity),
      ),
    );
  }

  Widget _buildCartItemActions(product_model.Product product, int quantity) {
    if (product.price == 0) {
      return IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => saleController.removeProductFromCartById(product.id,
            price: product.price),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => saleController.removeProductFromCart(product),
          ),
          Text(quantity.toString()),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => saleController.addProductToCart(product),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Change Qty & Price'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _showEditItemDialog(product, quantity);
              } else if (value == 'delete') {
                saleController.removeProductFromCartById(product.id,
                    price: product.price);
              }
            },
          ),
        ],
      );
    }
  }

  void _showEditItemDialog(product_model.Product product, int currentQuantity) {
    final quantityController =
        TextEditingController(text: currentQuantity.toString());
    final priceController =
        TextEditingController(text: product.price.toStringAsFixed(2));
    final isFree = product.price == 0;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price per unit',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (!isFree)
                InkWell(
                  onTap: () {
                    priceController.text = '0';
                  },
                  child: Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Free",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity =
                  int.tryParse(quantityController.text) ?? currentQuantity;
              final newPrice =
                  double.tryParse(priceController.text) ?? product.price;

              if (newQuantity > 0) {
                saleController.updateProductQuantity(product, newQuantity);
                saleController.updateProductPrice(product, newPrice);
              }

              if (Get.isDialogOpen == true) {
                Get.back();
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartFooter() {
    return Column(
      children: [
        const Divider(),
        _buildTotalRow("Subtotal", saleController.formattedSubtotal),
        Obx(() {
          if (saleController.saleDiscount.value > 0) {
            final discountType = saleController.lastDiscountType.value;
            final typeText =
                discountType == 'percent' ? '(percent)' : '(amount)';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount $typeText',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        '${saleController.formattedDiscount}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => saleController.clearDiscount(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        _buildTotalRow(
          "Grand Total",
          saleController.formattedTotal,
          isTotal: true,
        ),
        const SizedBox(height: 16),
        _buildPayButton(),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? Colors.green
                  : isDiscount
                      ? Colors.red
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          if (saleController.cartItems.isEmpty) {
            _showSnackbar(
                'Empty Cart', 'Please add items to cart before payment');
            return;
          }
          saleController.showPaymentDialog();
        },
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PAY',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '\$${saleController.saleTotal.value.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
