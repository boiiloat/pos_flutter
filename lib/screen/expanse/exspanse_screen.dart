import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/sale_controller.dart';
import 'package:pos_system/utils/constants.dart';

import '../../controller/exspanse_controller.dart';
import '../../models/exspanse_model.dart';

class ExpenseScreen extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final SaleController saleController = Get.put(SaleController());

  ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Expanse Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: expenseController.fetchExpenses,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with title
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 150,
                height: 40,
                decoration: _boxDecoration(),
                child: InkWell(
                  onTap: () => _showAddExpenseDialog(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle),
                      SizedBox(width: 8),
                      Text('Expense'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Expenses table
          Expanded(
            child: _buildExpensesTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTable() {
    return Obx(() {
      if (expenseController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (expenseController.expenses.isEmpty) {
        return const Center(
          child: Text(
            'No expenses found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table header
              _buildTableHeader(),

              // Table content
              Expanded(
                child: ListView.builder(
                  itemCount: expenseController.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenseController.expenses[index];
                    return _buildExpenseRow(expense, index);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('Ref.',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 2,
            child: Text('Description',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Amount',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Payment method',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Created by',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Created date',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Note',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            flex: 1,
            child: Text('Actions',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(Expense expense, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        color: index.isEven ? Colors.white : Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              expense.referenceNumber,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              expense.description,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              expense.paymentMethodName ?? 'N/A',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              expense.createdByName ?? 'Unknown',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              _formatDate(expense.createdAt),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              expense.note ?? '-',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                  onPressed: () => _showEditExpenseDialog(expense),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () => _showDeleteDialog(expense),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showAddExpenseDialog() {
    expenseController.clearForm();
    _showExpenseDialog(null);
  }

  void _showEditExpenseDialog(Expense expense) {
    expenseController.setFormData(expense);
    _showExpenseDialog(expense);
  }

  void _showExpenseDialog(Expense? expense) {
    // Create text controllers
    final descriptionController =
        TextEditingController(text: expenseController.description.value);
    final amountController = TextEditingController(
        text: expenseController.amount.value == 0
            ? ''
            : expenseController.amount.value.toString());
    final noteController =
        TextEditingController(text: expenseController.note.value);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 350, // Shorter width
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  expense == null ? 'Add Expense' : 'Edit Expense',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              _buildSectionHeader('Description'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) =>
                      expenseController.description.value = value,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: 'Enter description',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Amount
              _buildSectionHeader('Amount'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: amountController,
                  onChanged: (value) => expenseController.amount.value =
                      double.tryParse(value) ?? 0.0,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: '0.00',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Payment Method
              _buildSectionHeader('Payment Method'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    value: expenseController.paymentMethodId.value == 0
                        ? null
                        : expenseController.paymentMethodId.value,
                    items: saleController.paymentMethods.map((method) {
                      return DropdownMenuItem<int>(
                        value: int.parse(method.id),
                        child: Text(
                          method.paymentMethodName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        expenseController.paymentMethodId.value = value ?? 0,
                    hint: const Text(
                      'Select payment method',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Note
              _buildSectionHeader('Note (Optional)'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: noteController,
                  onChanged: (value) => expenseController.note.value = value,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: 'Add note...',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextButton(
                      onPressed: expenseController.loading.value
                          ? null
                          : () async {
                              // Validate form
                              if (expenseController.description.value.isEmpty) {
                                Get.snackbar(
                                    'Error', 'Please enter description');
                                return;
                              }
                              if (expenseController.amount.value <= 0) {
                                Get.snackbar(
                                    'Error', 'Please enter valid amount');
                                return;
                              }
                              if (expenseController.paymentMethodId.value ==
                                  0) {
                                Get.snackbar(
                                    'Error', 'Please select payment method');
                                return;
                              }

                              bool success;
                              if (expense == null) {
                                success = await expenseController.createExpense(
                                  description:
                                      expenseController.description.value,
                                  amount: expenseController.amount.value,
                                  paymentMethodId:
                                      expenseController.paymentMethodId.value,
                                  note: expenseController.note.value.isEmpty
                                      ? null
                                      : expenseController.note.value,
                                );
                              } else {
                                success = await expenseController
                                    .updateExpense(expense);
                              }

                              if (success) {
                                Get.back();
                              }
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                      ),
                      child: expenseController.loading.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : Text(
                              expense == null ? 'Create' : 'Update',
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method for section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
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
          offset: const Offset(0, 2),
        )
      ],
      borderRadius: BorderRadius.circular(5),
    );
  }

  void _showDeleteDialog(Expense expense) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Expense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete expense ${expense.referenceNumber}?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await expenseController.deleteExpense(expense);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
