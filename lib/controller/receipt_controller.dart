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
  var pieChartFilter = 'today'.obs;

  // KPI data
  var totalSale = 0.obs;
  var totalOrder = 0.obs;
  var totalRevenue = 0.0.obs;
  var totalProfit = 0.0.obs;

  // Date filtering
  var currentFilter = 'all'.obs;

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
          print('📅 Sale Date: ${sale.saleDate}');
          print('📅 Formatted: ${formatDateTime(sale.saleDate)}');
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

    // Get CURRENT SYSTEM DATE (today's actual date)
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final currentDay = now.day;

    List<Sale> filtered = [];

    switch (filterType) {
      case 'today':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate;
          return saleDate.year == currentYear &&
              saleDate.month == currentMonth &&
              saleDate.day == currentDay;
        }).toList();

        print(
            '📅 Today filter: Showing sales from $currentDay/$currentMonth/$currentYear');
        print('📊 Found ${filtered.length} sales for today');
        break;

      case 'month':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate;
          return saleDate.year == currentYear && saleDate.month == currentMonth;
        }).toList();

        print(
            '📅 Month filter: Showing sales from month $currentMonth/$currentYear');
        print('📊 Found ${filtered.length} sales for this month');
        break;

      case 'year':
        filtered = sales.where((sale) {
          final saleDate = sale.saleDate;
          return saleDate.year == currentYear;
        }).toList();

        print('📅 Year filter: Showing sales from year $currentYear');
        print('📊 Found ${filtered.length} sales for this year');
        break;

      case 'all':
      default:
        filtered = List.from(sales);
        print('📅 All filter: Showing all ${filtered.length} sales');
        break;
    }

    filteredSales.value = filtered;
    calculateKPIs(filteredSales);
  }

  void debugDateFiltering() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final currentDay = now.day;

    print('🔄 DEBUG DATE FILTERING =================');
    print('📅 CURRENT SYSTEM DATE: $currentDay/$currentMonth/$currentYear');
    print('📅 Current Filter: ${currentFilter.value}');

    if (sales.isNotEmpty) {
      print('📊 Total sales: ${sales.length}');

      // Group sales by date to see what dates we have
      final dateGroups = <String, List<Sale>>{};
      for (var sale in sales) {
        final dateKey =
            '${sale.saleDate.year}-${sale.saleDate.month.toString().padLeft(2, '0')}-${sale.saleDate.day.toString().padLeft(2, '0')}';
        if (!dateGroups.containsKey(dateKey)) {
          dateGroups[dateKey] = [];
        }
        dateGroups[dateKey]!.add(sale);
      }

      print('📅 Available dates in database:');
      dateGroups.keys
          .toList()
          .sort((a, b) => b.compareTo(a)); // Sort descending
      for (var dateKey in dateGroups.keys.take(10)) {
        final parts = dateKey.split('-');
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        print('   $day/$month/$year: ${dateGroups[dateKey]!.length} sales');
      }

      // Show today's expected filter results
      final todaySales = sales.where((sale) {
        return sale.saleDate.year == currentYear &&
            sale.saleDate.month == currentMonth &&
            sale.saleDate.day == currentDay;
      }).toList();

      print(
          '📅 Expected Today filter results: $currentDay/$currentMonth/$currentYear');
      print('📊 Expected sales count: ${todaySales.length}');
    }

    print('================================');
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

  String formatDateTime(DateTime dateTime) {
    final timeFormat =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    final dateFormat =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    return '$timeFormat / $dateFormat';
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  int get totalSalesCount => sales.length;

  String get salesDateRange {
    if (sales.isEmpty) return 'No sales data';
    final oldestSale = sales.last;
    final newestSale = sales.first;
    return '${formatDateTime(oldestSale.saleDate)} to ${formatDateTime(newestSale.saleDate)}';
  }

  Map<String, dynamic> get debugInfo {
    final now = DateTime.now();
    return {
      'totalSalesInMemory': sales.length,
      'filteredSales': filteredSales.length,
      'currentFilter': currentFilter.value,
      'loading': loading.value,
      'error': errorMessage.value,
      'dateRange': salesDateRange,
      'currentSystemDate': '${now.day}/${now.month}/${now.year}',
      'kpis': {
        'totalOrder': totalOrder.value,
        'totalSale': totalSale.value,
        'totalRevenue': totalRevenue.value,
        'totalProfit': totalProfit.value,
      },
      'recentSales': sales
          .take(5)
          .map((sale) =>
              'ID: ${sale.id}, Date: ${formatDateTime(sale.saleDate)}')
          .toList(),
    };
  }
}
