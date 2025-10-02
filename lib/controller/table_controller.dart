// lib/controller/table_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pos_system/program.dart';

import 'sale_controller.dart';

class TableController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var tableData = <Map<String, dynamic>>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  final RxBool isAdmin = false.obs;
  var selectedTableId = 0.obs;
  var selectedTableName = ''.obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    updateAdminStatus();
    fetchTables();
  }

  @override
  void onClose() {
    loading.value = false;
    super.onClose();
  }

  void updateAdminStatus() {
    final user = _storage.read('user') ?? {};
    final roleId = int.tryParse(user['role_id'].toString()) ?? 0;
    isAdmin.value = roleId == 1;
  }

  Future<void> fetchTables() async {
    try {
      loading.value = true;
      errorMessage.value = '';
      print('🔄 Fetching tables...');

      final response = await _dio.get(
        '/tables',
        options: dio.Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
      );

      if (response.statusCode == 200) {
        final tables = (response.data['data'] as List)
            .map((tableJson) => {
                  'id': _safeParseInt(tableJson['id']),
                  'name': _safeParseString(tableJson['name']),
                  'created_at': _safeParseString(tableJson['created_at']),
                  'updated_at': _safeParseString(tableJson['updated_at']),
                  'created_by': _safeParseString(tableJson['created_by']),
                  'created_by_id': _safeParseInt(tableJson['created_by_id']),
                  'deleted_at': tableJson['deleted_at'],
                })
            .toList();

        tableData.assignAll(tables);
        print('✅ Tables fetched successfully. Count: ${tables.length}');
      } else {
        throw response.data['message']?.toString() ?? 'Failed to fetch tables';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Fetch tables error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> createTable(String name) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      final response = await _dio.post(
        '/tables',
        data: {'name': name},
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Table created successfully');
        await fetchTables(); // Wait for table list refresh
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to create table';
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create table: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateTable(int tableId, String name) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      final response = await _dio.put(
        '/tables/$tableId',
        data: {'name': name},
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Program.success(
            'Table Updated', 'Table $name has been updated successfully');
        await fetchTables(); // Wait for table list refresh
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to update table';
        Program.error('Update Failed', errorMsg);
      }
    } catch (e) {
      Program.error('Update Failed', 'Failed to update table: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteTable(int tableId) async {
    try {
      loading.value = true;
      final token = _storage.read('token');

      print('🗑️ Deleting table ID: $tableId');

      final response = await _dio.delete(
        '/tables/$tableId',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('✅ Delete response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        Program.success('Table Deleted', 'Table has been deleted successfully');
        // Force refresh the table list
        await fetchTables();
        print('✅ Table list refreshed after delete');
      } else {
        final data = response.data;
        final errorMsg = data is Map && data.containsKey('message')
            ? data['message']
            : 'Failed to delete table';
        Program.error('Delete Failed', errorMsg);
      }
    } catch (e) {
      print('❌ Delete table error: $e');
      Program.error('Delete Failed', 'Failed to delete table: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }

  void selectTable(int tableId, String tableName) {
    selectedTableId.value = tableId;
    selectedTableName.value = tableName;
    print('Table selected - ID: $tableId, Name: $tableName');

    // Update SaleController if it exists
    if (Get.isRegistered<SaleController>()) {
      final saleController = Get.find<SaleController>();
      saleController.setCurrentTable(tableId, tableName);
      print('Updated SaleController with table selection');
    } else {
      print('SaleController not registered yet');
    }
  }

  Future<void> deleteTableWithConfirmation(int tableId) async {
    if (isDeleting.value) return; // Prevent multiple clicks

    try {
      isDeleting.value = true;
      loading.value = true;

      final token = _storage.read('token');
      final response = await _dio.delete(
        '/tables/$tableId',
        options: dio.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Program.success(
            'Table Deleted', 'Table ID $tableId has been deleted successfully');
        // Force immediate refresh
        await fetchTables();
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to delete table';
        Program.error('Delete Failed', errorMsg);
      }
    } catch (e) {
      Program.error('Delete Failed', 'Failed to delete table: ${e.toString()}');
    } finally {
      isDeleting.value = false;
      loading.value = false;
    }
  }

  void resetForNewSale() {
    print('🔄 Resetting table controller for new sale...');
    loading.value = false;
    print(
        '✅ Table controller reset - Current table: ${selectedTableName.value}');
  }

  Map<String, dynamic> getSelectedTableInfo() {
    return {
      'id': selectedTableId.value,
      'name': selectedTableName.value,
    };
  }

  void clearSelection() {
    print('🗂️ Clearing table selection for fresh start...');
    selectedTableId.value = 0;
    selectedTableName.value = '';
    loading.value = false;
    print('✅ Table selection cleared - Ready for fresh table selection');
  }

  static int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _safeParseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
