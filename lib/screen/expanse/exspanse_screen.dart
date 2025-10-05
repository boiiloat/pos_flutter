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
          // Header with title and filters
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date Filter
                _buildDateFilter(),

                // Total Expense and Add Expense Button
                Row(
                  children: [
                    // Total Expense
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: _boxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total Expense',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${expenseController.getFilteredTotal().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 12),

                    // Add Expense Button
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
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter Info
          Obx(() => expenseController.hasActiveFilter.value
              ? _buildFilterInfo()
              : const SizedBox()),

          // Expenses table
          Expanded(
            child: _buildExpensesTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      decoration: _boxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Obx(() => Text(
                _getDateFilterText(),
                style: TextStyle(
                  fontSize: 14,
                  color: expenseController.hasActiveFilter.value
                      ? Colors.blue
                      : Colors.grey.shade600,
                ),
              )),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            onSelected: (value) => _handleDateFilterSelection(value),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'today',
                child: ListTile(
                  leading: Icon(Icons.today),
                  title: Text('Today'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'yesterday',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_day),
                  title: Text('Yesterday'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'this_week',
                child: ListTile(
                  leading: Icon(Icons.view_week),
                  title: Text('This Week'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'this_month',
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('This Month'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'last_month',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_month),
                  title: Text('Last Month'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'custom',
                child: ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Custom Range'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear),
                  title: Text('Clear Filter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Obx(() => Text(
                expenseController.getFilterDescription(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              )),
          const SizedBox(width: 16),
          InkWell(
            onTap: () => expenseController.clearDateFilter(),
            child: Row(
              children: [
                Icon(Icons.clear, size: 14, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDateFilterText() {
    if (expenseController.hasActiveFilter.value) {
      return expenseController.currentFilter.value;
    }
    return 'Date Filter';
  }

  void _handleDateFilterSelection(String value) {
    switch (value) {
      case 'today':
        expenseController.applyDateFilter('today');
        break;
      case 'yesterday':
        expenseController.applyDateFilter('yesterday');
        break;
      case 'this_week':
        expenseController.applyDateFilter('this_week');
        break;
      case 'this_month':
        expenseController.applyDateFilter('this_month');
        break;
      case 'last_month':
        expenseController.applyDateFilter('last_month');
        break;
      case 'custom':
        _showCustomDateRangeDialog();
        break;
      case 'clear':
        expenseController.clearDateFilter();
        break;
    }
  }

  void _showCustomDateRangeDialog() {
    DateTime? fromDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime? toDate = DateTime.now();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // From Date
              _buildDatePickerField(
                label: 'From Date',
                initialDate: fromDate,
                onDateSelected: (date) => fromDate = date,
              ),
              const SizedBox(height: 16),

              // To Date
              _buildDatePickerField(
                label: 'To Date',
                initialDate: toDate,
                onDateSelected: (date) => toDate = date,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (fromDate != null && toDate != null) {
                        expenseController.applyCustomDateFilter(
                            fromDate!, toDate!);
                        Get.back();
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? initialDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              initialDate != null
                  ? _formatDateForDisplay(initialDate!)
                  : 'Select date',
              style: TextStyle(
                color: initialDate != null ? Colors.black : Colors.grey,
              ),
            ),
            trailing: const Icon(Icons.calendar_today, size: 20),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: Get.context!,
                initialDate: initialDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (selectedDate != null) {
                onDateSelected(selectedDate);
                // Update the UI
                Get.find<ExpenseController>().update();
              }
            },
          ),
        ),
      ],
    );
  }

  String _formatDateForDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildExpensesTable() {
    return Obx(() {
      if (expenseController.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final displayExpenses = expenseController.hasActiveFilter.value
          ? expenseController.filteredExpenses
          : expenseController.expenses;

      if (displayExpenses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                expenseController.hasActiveFilter.value
                    ? 'No expenses found for selected period'
                    : 'No expenses found',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (expenseController.hasActiveFilter.value)
                TextButton(
                  onPressed: () => expenseController.clearDateFilter(),
                  child: const Text('Clear Filter'),
                ),
            ],
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
              // Table header with column labels
              _buildTableHeader(),

              // Table content
              Expanded(
                child: ListView.builder(
                  itemCount: displayExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = displayExpenses[index];
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
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    int? selectedPaymentMethodId;

    // Initialize form data
    if (expense != null) {
      descriptionController.text = expense.description;
      amountController.text = expense.amount.toString();
      noteController.text = expense.note ?? '';
      selectedPaymentMethodId = expense.paymentMethodId;
    } else {
      descriptionController.text = expenseController.description.value;
      amountController.text = expenseController.amount.value == 0
          ? ''
          : expenseController.amount.value.toString();
      noteController.text = expenseController.note.value;
      selectedPaymentMethodId = expenseController.paymentMethodId.value == 0
          ? null
          : expenseController.paymentMethodId.value;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 350,
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
                    value: selectedPaymentMethodId,
                    items: saleController.paymentMethods.map((method) {
                      return DropdownMenuItem<int>(
                        value: int.parse(method.id),
                        child: Text(
                          method.paymentMethodName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedPaymentMethodId = value;
                    },
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
                              // Get values directly from controllers
                              final description =
                                  descriptionController.text.trim();
                              final amountText = amountController.text.trim();
                              final note = noteController.text.trim();

                              // Validate form
                              if (description.isEmpty) {
                                Get.snackbar(
                                    'Error', 'Please enter description');
                                return;
                              }

                              final amount = double.tryParse(amountText);
                              if (amount == null || amount <= 0) {
                                Get.snackbar(
                                    'Error', 'Please enter valid amount');
                                return;
                              }

                              if (selectedPaymentMethodId == null) {
                                Get.snackbar(
                                    'Error', 'Please select payment method');
                                return;
                              }

                              bool success;
                              if (expense == null) {
                                success = await expenseController.createExpense(
                                  description: description,
                                  amount: amount,
                                  paymentMethodId: selectedPaymentMethodId!,
                                  note: note.isEmpty ? null : note,
                                );
                              } else {
                                // For update, we need to create an updated expense object
                                final updatedExpense = Expense(
                                  id: expense.id,
                                  description: description,
                                  amount: amount,
                                  paymentMethodId: selectedPaymentMethodId!,
                                  note: note.isEmpty ? null : note,
                                  referenceNumber: expense.referenceNumber,
                                  createdAt: expense.createdAt,
                                  createdByName: expense.createdByName,
                                  paymentMethodName: expense.paymentMethodName,
                                  createdBy: expense.createdBy,
                                  updatedAt:
                                      expense.updatedAt ?? DateTime.now(),
                                );
                                success = await expenseController
                                    .updateExpense(updatedExpense);
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
