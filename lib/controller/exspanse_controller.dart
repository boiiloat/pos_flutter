import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import '../models/exspanse_model.dart';

class ExpenseController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var expenses = <Expense>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;

  // For form
  var description = ''.obs;
  var amount = 0.0.obs;
  var paymentMethodId = 0.obs;
  var note = ''.obs;

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
      } else {
        throw 'Failed to load expenses: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
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
        'note': note,
      };

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
        await fetchExpenses();
        return true;
      } else {
        throw 'Failed to create expense: ${response.statusCode}';
      }
    } catch (e) {
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
        'note': expense.note,
      };

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
        await fetchExpenses();
        return true;
      } else {
        throw 'Failed to update expense: ${response.statusCode}';
      }
    } catch (e) {
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
        expenses.removeWhere((e) => e.id == expense.id);
        return true;
      } else {
        throw 'Failed to delete expense: ${response.statusCode}';
      }
    } catch (e) {
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
