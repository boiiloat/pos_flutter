import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../controller/product_controller.dart';
import '../../models/api/product_model.dart';
import '../../utils/constants.dart';

class ProductScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCTS', style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.fetchProducts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSearchBox(),
                if (controller.isAdmin.value) _buildAddButton(),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilterSortRow(),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: _boxDecoration(),
                child: Obx(() {
                  if (controller.loading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                        child: Text('Error: ${controller.errorMessage.value}'));
                  }
                  if (controller.filteredProducts.isEmpty) {
                    return Center(
                      child: Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'No matching products found'
                            : 'No products found',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: _buildHeaderRow(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            return _buildDataRow(product);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 200,
      height: 40,
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchQuery.value = '';
                    controller
                        .filterProducts(); // Changed from controller._filterProducts()
                  },
                )
              : const Icon(Icons.search, color: Colors.black)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _inputBorder(),
          enabledBorder: _inputBorder(),
          focusedBorder: _inputBorder(),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () => _showAddProductDialog(),
      child: Container(
        width: 150,
        height: 38,
        decoration: _boxDecoration(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle),
            SizedBox(width: 10),
            Text('Add Product', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSortRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: _boxDecoration(),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Filter by Category',
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('All Categories'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Category 1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Category 2'),
                ),
              ],
              onChanged: (value) => controller.filterByCategory(value ?? 0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: _boxDecoration(),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Sort By',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'name_asc',
                  child: Text('Name (A-Z)'),
                ),
                DropdownMenuItem(
                  value: 'name_desc',
                  child: Text('Name (Z-A)'),
                ),
                DropdownMenuItem(
                  value: 'price_asc',
                  child: Text('Price (Low to High)'),
                ),
                DropdownMenuItem(
                  value: 'price_desc',
                  child: Text('Price (High to Low)'),
                ),
              ],
              onChanged: (value) {
                switch (value) {
                  case 'name_asc':
                    controller.sortByName(ascending: true);
                    break;
                  case 'name_desc':
                    controller.sortByName(ascending: false);
                    break;
                  case 'price_asc':
                    controller.sortByPrice(ascending: true);
                    break;
                  case 'price_desc':
                    controller.sortByPrice(ascending: false);
                    break;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        Expanded(
            flex: 2, child: Center(child: Text('Image', style: _headerStyle))),
        Expanded(
            flex: 3, child: Center(child: Text('Name', style: _headerStyle))),
        Expanded(
            flex: 2, child: Center(child: Text('Price', style: _headerStyle))),
        Expanded(
            flex: 3,
            child: Center(child: Text('Category', style: _headerStyle))),
        Expanded(
            flex: 3,
            child: Center(child: Text('Created By', style: _headerStyle))),
        Expanded(
            flex: 2, child: Center(child: Text('Action', style: _headerStyle))),
      ],
    );
  }

  Widget _buildDataRow(Product product) {
    final imageUrl = (product.image != null && product.image!.isNotEmpty)
        ? 'http://127.0.0.1:8000/storage/${product.image}'
        : 'assets/images/logo_image.jpg';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(flex: 3, child: Center(child: Text(product.name ?? 'N/A'))),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('\$${product.price?.toStringAsFixed(2) ?? '0.00'}'),
            ),
          ),
          Expanded(
              flex: 3,
              child: Center(child: Text(product.categoryName ?? 'Unknown'))),
          Expanded(
            flex: 3,
            child: Center(
                child: Text(product.creatorName ?? product.createdBy ?? 'N/A')),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isAdmin.value)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditProductDialog(product),
                    ),
                  if (controller.isAdmin.value)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(product.id!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    nameController.clear();
    priceController.clear();
    categoryController.clear();
    controller.selectedImage.value = null;

    Get.defaultDialog(
      title: 'Add New Product',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isEmpty ||
              priceController.text.isEmpty ||
              categoryController.text.isEmpty) {
            Get.snackbar('Error', 'Please fill all fields');
            return;
          }

          final price = double.tryParse(priceController.text);
          final categoryId = int.tryParse(categoryController.text);

          if (price == null || categoryId == null) {
            Get.snackbar('Error', 'Invalid price or category ID');
            return;
          }

          final success = await controller.createProduct(
            name: nameController.text,
            price: price,
            categoryId: categoryId,
            imageInfo: controller.selectedImage.value,
          );

          if (success) {
            Get.back();
          }
        },
        child: const Text('Save'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    nameController.text = product.name ?? '';
    priceController.text = product.price?.toString() ?? '0';
    categoryController.text = product.categoryId?.toString() ?? '';
    controller.selectedImage.value = null;

    Get.defaultDialog(
      title: 'Edit Product',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildImagePicker(currentImageUrl: product.image),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          if (nameController.text.isEmpty ||
              priceController.text.isEmpty ||
              categoryController.text.isEmpty) {
            Get.snackbar('Error', 'Please fill all fields');
            return;
          }

          final price = double.tryParse(priceController.text);
          final categoryId = int.tryParse(categoryController.text);

          if (price == null || categoryId == null) {
            Get.snackbar('Error', 'Invalid price or category ID');
            return;
          }

          final success = await controller.updateProduct(
            productId: product.id!,
            name: nameController.text,
            price: price,
            categoryId: categoryId,
            imageInfo: controller.selectedImage.value,
          );

          if (success) {
            Get.back();
          }
        },
        child: const Text('Update'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }

  Widget _buildImagePicker({String? currentImageUrl}) {
    return Column(
      children: [
        Obx(() {
          if (controller.selectedImage.value != null) {
            return Image.memory(
              controller.selectedImage.value!.bytes,
              height: 100,
              fit: BoxFit.cover,
            );
          }
          return currentImageUrl != null && currentImageUrl.isNotEmpty
              ? Image.network(
                  'http://127.0.0.1:8000/storage/$currentImageUrl',
                  height: 100,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey,
                  child: const Icon(Icons.image, size: 50),
                );
        }),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final image = await ImagePickerWeb.getImageAsBytes();
            if (image != null) {
              final filename =
                  'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
              controller.selectedImage.value = WebImageInfo(
                bytes: image,
                filename: filename,
              );
            }
          },
          child: const Text('Select Image'),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(int productId) {
    Get.defaultDialog(
      title: 'Confirm Delete',
      middleText: 'Are you sure you want to delete this product?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final success = await controller.deleteProduct(productId);
        if (success) {
          Get.back();
        }
      },
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 2),
        )
      ],
      borderRadius: BorderRadius.circular(5),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 14,
  );
}
