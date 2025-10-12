import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/category_controller.dart';
import '../../models/api/category_model.dart';
import '../../utils/constants.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: const Text('Category', style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.fetchCategories,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
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
                _buildAddButton(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: _boxDecoration(),
                child: _buildCategoryList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredCategories.isEmpty) {
        return Center(
          child: Text(
            controller.searchQuery.isNotEmpty
                ? 'No matching categories found'
                : 'No categories found',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }

      return Column(
        children: [
          // Header
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
          // Content
          Expanded(
            child: ListView(
              children: List.generate(
                controller.filteredCategories.length,
                (index) => _buildDataRow(
                  controller.filteredCategories[index],
                  index,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        Expanded(
            flex: 1, child: Center(child: Text('No', style: _headerStyle))),
        Expanded(
            flex: 3, child: Center(child: Text('Name', style: _headerStyle))),
        Expanded(
            flex: 2,
            child: Center(child: Text('Created By', style: _headerStyle))),
        Expanded(
            flex: 2,
            child: Center(child: Text('Created Date', style: _headerStyle))),
        Expanded(
            flex: 2,
            child: Center(child: Text('Actions', style: _headerStyle))),
      ],
    );
  }

  Widget _buildDataRow(Category category, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text('${index + 1}'))),
          Expanded(flex: 3, child: Center(child: Text(category.name))),
          Expanded(flex: 2, child: Center(child: Text(category.createdBy))),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                _formatDate(category.createdDate),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: () =>
                        controller.showEditCategoryDialog(category.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () =>
                        controller.showDeleteCategoryDialog(category.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      // Parse the date string to DateTime
      DateTime dateTime = DateTime.parse(dateString);
      // Format to dd-MM-yyyy
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      // Return original string if parsing fails
      return dateString;
    }
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
          suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: controller.clearSearch,
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
      onTap: controller.showAddCategoryDialog,
      child: Container(
        width: 150,
        height: 38,
        decoration: _boxDecoration(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle),
            SizedBox(width: 10),
            Text('Add Category', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2)),
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
