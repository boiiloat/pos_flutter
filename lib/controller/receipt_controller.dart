import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import '../models/api/sale_model.dart';

class ReceiptController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final GetStorage _storage = GetStorage();

  var sales = <Sale>[].obs;
  var filteredSales = <Sale>[].obs;
  var loading = false.obs;
  var errorMessage = ''.obs;
  var pieChartFilter = 'today'.obs; // 'today' or 'month'

  // KPI data
  var totalSale = 0.obs;
  var totalOrder = 0.obs;
  var totalRevenue = 0.0.obs;
  var totalProfit = 0.0.obs;

  // Date filtering
  var currentFilter = 'all'.obs; // 'all', 'today', 'month', 'year'

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = 'http://127.0.0.1:8000/api';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    fetchAllSales();
  }

  Future<void> fetchAllSales() async {
    try {
      loading.value = true;
      errorMessage.value = '';
      print('🔄 Fetching ALL sales data...');

      final response = await _dio.get(
        '/sales',
        options: dio.Options(headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        }),
      );

      print('📊 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<Sale> allSales = [];

        if (response.data is List) {
          allSales = (response.data as List)
              .map((saleJson) => Sale.fromJson(saleJson))
              .toList();
        } else if (response.data['data'] is List) {
          allSales = (response.data['data'] as List)
              .map((saleJson) => Sale.fromJson(saleJson))
              .toList();
        } else if (response.data['sales'] is List) {
          allSales = (response.data['sales'] as List)
              .map((saleJson) => Sale.fromJson(saleJson))
              .toList();
        } else {
          throw 'Unexpected API response format';
        }

        print('🎯 Total sales fetched from API: ${allSales.length}');

        final paidSales = _filterPaidSales(allSales);
        print('✅ Paid sales after filtering: ${paidSales.length}');

        // Sort by saleDate in descending order (newest first)
        paidSales.sort((a, b) => b.saleDate.compareTo(a.saleDate));

        sales.value = paidSales;
        applyDateFilter(currentFilter.value);

        calculateKPIs(filteredSales);

        print('🎉 FINAL RESULTS =================');
        print('📈 Total paid sales: ${paidSales.length}');
        print('📊 Filtered sales: ${filteredSales.length}');
        print('🔍 Current filter: $currentFilter');

        // Debug: Print dates to verify
        for (var sale in paidSales.take(3)) {
          print('📅 Sale Date - Original: ${sale.saleDate}');
          print('📅 Sale Date - Local: ${sale.saleDate.toLocal()}');
          print('📅 Sale Date - UTC: ${sale.saleDate.toUtc()}');
        }
        print('================================');
      } else {
        throw response.data['message']?.toString() ??
            'Failed to fetch sales. Status: ${response.statusCode}';
      }
    } catch (e) {
      print('❌ Error fetching sales: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load sales data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      loading.value = false;
    }
  }

  void applyDateFilter(String filterType) {
    currentFilter.value = filterType;

    if (sales.isEmpty) return;

    final now = DateTime.now().toUtc(); // Use UTC for comparison
    List<Sale> filtered = [];

    switch (filterType) {
      case 'today':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate; // Already UTC from model
          return saleDate.year == now.year &&
              saleDate.month == now.month &&
              saleDate.day == now.day;
        }).toList();
        break;

      case 'month':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate; // Already UTC from model
          return saleDate.year == now.year && saleDate.month == now.month;
        }).toList();
        break;

      case 'year':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate; // Already UTC from model
          return saleDate.year == now.year;
        }).toList();
        break;

      case 'all':
      default:
        filtered = List.from(sales);
        break;
    }

    filteredSales.value = filtered;
    calculateKPIs(filteredSales);

    print('🔍 Applied filter: $filterType');
    print('📊 Filtered sales count: ${filtered.length}');
  }

  List<Sale> _filterPaidSales(List<Sale> allSales) {
    print('🔍 FILTERING PAID SALES =================');
    print('📦 Total sales to filter: ${allSales.length}');

    final paidSales = allSales.where((sale) {
      final isPaid = sale.isPaid && sale.status == 'completed';
      return isPaid;
    }).toList();

    print('✅ Paid sales: ${paidSales.length}');
    print('❌ Non-paid sales: ${allSales.length - paidSales.length}');
    print('================================');

    return paidSales;
  }

  void calculateKPIs(List<Sale> salesList) {
    totalOrder.value = salesList.length;

    totalSale.value = salesList.fold(0, (sum, sale) {
      return sum + sale.products.length;
    });

    totalRevenue.value = salesList.fold(0.0, (sum, sale) {
      return sum + sale.grandTotal;
    });

    totalProfit.value = salesList.fold(0.0, (sum, sale) {
      return sum + (sale.grandTotal - sale.discount);
    });

    print('📊 KPI Calculation for ${salesList.length} sales:');
    print('   👥 Total Orders: $totalOrder');
    print('   📦 Total Sale Items: $totalSale');
    print('   💰 Total Revenue: \$${totalRevenue.value.toStringAsFixed(2)}');
    print('   💵 Total Profit: \$${totalProfit.value.toStringAsFixed(2)}');
  }

  Future<void> forceRefreshSales() async {
    print('🔄 FORCE REFRESHING ALL SALES DATA...');

    sales.clear();
    filteredSales.clear();

    totalSale.value = 0;
    totalOrder.value = 0;
    totalRevenue.value = 0.0;
    totalProfit.value = 0.0;

    await fetchAllSales();
  }

  void refreshSales() {
    fetchAllSales();
  }

  void setPieChartFilter(String filter) {
    pieChartFilter.value = filter;
  }

// In ReceiptController - update the formatDateTime method
  String formatDateTime(DateTime dateTime) {
    // Since dates are now stored as UTC in the model, display them as-is
    // This will match exactly what's in the database
    final timeFormat =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final dateFormat =
        '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
    return '$timeFormat / $dateFormat';
  }

  // Alternative: If you want to display local time but filter correctly
  String formatDateTimeLocal(DateTime dateTime) {
    final localDate = dateTime.toLocal();
    final timeFormat =
        '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    final dateFormat =
        '${localDate.day.toString().padLeft(2, '0')}-${localDate.month.toString().padLeft(2, '0')}-${localDate.year}';
    return '$timeFormat / $dateFormat';
  }

  int get totalSalesCount => sales.length;

  String get salesDateRange {
    if (sales.isEmpty) return 'No sales data';
    final oldestSale = sales.last;
    final newestSale = sales.first;
    return '${formatDateTime(oldestSale.saleDate)} to ${formatDateTime(newestSale.saleDate)}';
  }

  Map<String, dynamic> get debugInfo {
    return {
      'totalSalesInMemory': sales.length,
      'filteredSales': filteredSales.length,
      'currentFilter': currentFilter.value,
      'loading': loading.value,
      'error': errorMessage.value,
      'dateRange': salesDateRange,
      'kpis': {
        'totalOrder': totalOrder.value,
        'totalSale': totalSale.value,
        'totalRevenue': totalRevenue.value,
        'totalProfit': totalProfit.value,
      },
      'recentSales': sales
          .take(5)
          .map((sale) => 'ID: ${sale.id}, Date: ${sale.saleDate}')
          .toList(),
    };
  }
}
