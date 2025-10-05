import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import '../models/exspanse_model.dart';

class ExpenseController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var expenses = <Expense>[].obs;
  var filteredExpenses = <Expense>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;

  // For form
  var description = ''.obs;
  var amount = 0.0.obs;
  var paymentMethodId = 0.obs;
  var note = ''.obs;

  // Date filtering
  var hasActiveFilter = false.obs;
  var currentFilter = 'all'.obs;
  DateTime? fromDateFilter;
  DateTime? toDateFilter;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      loading.value = true;
      errorMessage.value = '';

      final token = _storage.read('token');
      if (token == null) {
        throw 'No authentication token found. Please login first.';
      }

      final response = await _dio.get(
        '/expenses',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          expenses.value =
              (response.data as List).map((e) => Expense.fromJson(e)).toList();
        } else if (response.data is Map && response.data['data'] is List) {
          expenses.value = (response.data['data'] as List)
              .map((e) => Expense.fromJson(e))
              .toList();
        } else {
          throw 'Unexpected response format';
        }

        // Apply current filter if any
        if (hasActiveFilter.value) {
          applyCurrentFilter();
        } else {
          filteredExpenses.assignAll(expenses);
        }

        print('✅ Expenses loaded: ${expenses.length}');
      } else {
        throw 'Failed to load expenses: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load expenses: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }

  void applyDateFilter(String filterType) {
    currentFilter.value = filterType;
    hasActiveFilter.value = true;

    final now = DateTime.now();

    switch (filterType) {
      case 'today':
        fromDateFilter = DateTime(now.year, now.month, now.day);
        toDateFilter = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        fromDateFilter =
            DateTime(yesterday.year, yesterday.month, yesterday.day);
        toDateFilter = DateTime(
            yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'this_week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        fromDateFilter =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        toDateFilter = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'this_month':
        fromDateFilter = DateTime(now.year, now.month, 1);
        toDateFilter = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'last_month':
        final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);
        fromDateFilter = firstDayLastMonth;
        toDateFilter = lastDayLastMonth;
        break;
    }

    applyCurrentFilter();
  }

  void applyCustomDateFilter(DateTime fromDate, DateTime toDate) {
    currentFilter.value = 'custom';
    hasActiveFilter.value = true;
    fromDateFilter = fromDate;
    toDateFilter = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59);
    applyCurrentFilter();
  }

  void applyCurrentFilter() {
    if (!hasActiveFilter.value ||
        fromDateFilter == null ||
        toDateFilter == null) {
      filteredExpenses.assignAll(expenses);
      return;
    }

    filteredExpenses.assignAll(expenses.where((expense) {
      return expense.createdAt
              .isAfter(fromDateFilter!.subtract(const Duration(seconds: 1))) &&
          expense.createdAt.isBefore(toDateFilter!);
    }).toList());
  }

  void clearDateFilter() {
    hasActiveFilter.value = false;
    currentFilter.value = 'all';
    fromDateFilter = null;
    toDateFilter = null;
    filteredExpenses.assignAll(expenses);
  }

  String getFilterDescription() {
    if (!hasActiveFilter.value) return 'All expenses';

    switch (currentFilter.value) {
      case 'today':
        return 'Today\'s expenses';
      case 'yesterday':
        return 'Yesterday\'s expenses';
      case 'this_week':
        return 'This week\'s expenses';
      case 'this_month':
        return 'This month\'s expenses';
      case 'last_month':
        return 'Last month\'s expenses';
      case 'custom':
        return 'Custom range: ${_formatDate(fromDateFilter!)} to ${_formatDate(toDateFilter!)}';
      default:
        return 'Filtered expenses';
    }
  }

  double getFilteredTotal() {
    return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<bool> createExpense({
    required String description,
    required double amount,
    required int paymentMethodId,
    String? note,
  }) async {
    try {
      loading.value = true;

      final token = _storage.read('token');
      if (token == null) {
        throw 'No authentication token found';
      }

      final data = {
        'description': description,
        'amount': amount,
        'payment_method_id': paymentMethodId,
        if (note != null && note.isNotEmpty) 'note': note,
      };

      print('📤 Creating expense: $data');

      final response = await _dio.post(
        '/expenses',
        data: data,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Expense created successfully');
        await fetchExpenses();
        return true;
      } else {
        throw 'Failed to create expense: ${response.statusCode} - ${response.data}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create expense: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    try {
      loading.value = true;

      final token = _storage.read('token');
      if (token == null) {
        throw 'No authentication token found';
      }

      final data = {
        'description': expense.description,
        'amount': expense.amount,
        'payment_method_id': expense.paymentMethodId,
        if (expense.note != null && expense.note!.isNotEmpty)
          'note': expense.note,
      };

      print('📤 Updating expense ${expense.id}: $data');

      final response = await _dio.put(
        '/expenses/${expense.id}',
        data: data,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Expense updated successfully');
        await fetchExpenses();
        return true;
      } else {
        throw 'Failed to update expense: ${response.statusCode} - ${response.data}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update expense: ${e.toString()}');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> deleteExpense(Expense expense) async {
    try {
      final token = _storage.read('token');
      if (token == null) {
        throw 'No authentication token found';
      }

      final response = await _dio.delete(
        '/expenses/${expense.id}',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Expense deleted successfully');
        expenses.removeWhere((e) => e.id == expense.id);
        filteredExpenses.removeWhere((e) => e.id == expense.id);
        return true;
      } else {
        throw 'Failed to delete expense: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete expense: ${e.toString()}');
      return false;
    }
  }

  void setFormData(Expense? expense) {
    if (expense != null) {
      description.value = expense.description;
      amount.value = expense.amount;
      paymentMethodId.value = expense.paymentMethodId;
      note.value = expense.note ?? '';
    } else {
      clearForm();
    }
  }

  void clearForm() {
    description.value = '';
    amount.value = 0.0;
    paymentMethodId.value = 0;
    note.value = '';
  }

  double get totalAmount {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
