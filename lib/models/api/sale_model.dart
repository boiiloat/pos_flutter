class Sale {
  final int id;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final bool isPaid;
  final String status;
  final DateTime saleDate;
  final Map<String, dynamic> createdBy;
  final String invoiceNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> products;
  final int? tableId;
  final Map<String, dynamic>? table;

  Sale({
    required this.id,
    required this.subTotal,
    required this.discount,
    required this.grandTotal,
    required this.isPaid,
    required this.status,
    required this.saleDate,
    required this.createdBy,
    required this.invoiceNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
    this.tableId,
    this.table,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] as int,
      subTotal: (json['sub_total'] is String)
          ? double.parse(json['sub_total'])
          : (json['sub_total'] as num).toDouble(),
      discount: (json['discount'] is String)
          ? double.parse(json['discount'])
          : (json['discount'] as num).toDouble(),
      grandTotal: (json['grand_total'] is String)
          ? double.parse(json['grand_total'])
          : (json['grand_total'] as num).toDouble(),
      isPaid: json['is_paid'] as bool,
      status: json['status'] as String,
      // FIX: Parse dates as UTC to match database
      saleDate: _parseDateTime(json['sale_date'] as String?),
      createdBy: json['created_by'] is Map
          ? Map<String, dynamic>.from(json['created_by'])
          : {'fullname': 'Unknown'},
      invoiceNumber: json['invoice_number'] as String,
      // FIX: Parse dates as UTC to match database
      createdAt: _parseDateTime(json['created_at'] as String?),
      // FIX: Parse dates as UTC to match database
      updatedAt: _parseDateTime(json['updated_at'] as String?),
      products: json['products'] != null ? (json['products'] as List) : [],
      tableId: json['table_id'] as int?,
      table: json['table'] is Map
          ? Map<String, dynamic>.from(json['table'])
          : null,
    );
  }

  // Helper method to parse dates as UTC
  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null) return DateTime.now().toUtc();

    try {
      // Parse the date string and convert to UTC
      // This handles database format like "2025-10-01 17:39:35"
      DateTime parsedDate;

      if (dateString.contains('T')) {
        // ISO format with T
        parsedDate = DateTime.parse(dateString);
      } else {
        // Database format without T (2025-10-01 17:39:35)
        // Replace space with T to make it ISO format
        parsedDate = DateTime.parse(dateString.replaceFirst(' ', 'T'));
      }

      // Convert to UTC to match database storage
      return parsedDate.toUtc();
    } catch (e) {
      print('Error parsing date: $dateString, error: $e');
      return DateTime.now().toUtc();
    }
  }

  // Add copyWith method
  Sale copyWith({
    int? id,
    double? subTotal,
    double? discount,
    double? grandTotal,
    bool? isPaid,
    String? status,
    DateTime? saleDate,
    Map<String, dynamic>? createdBy,
    String? invoiceNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<dynamic>? products,
    int? tableId,
    Map<String, dynamic>? table,
  }) {
    return Sale(
      id: id ?? this.id,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      isPaid: isPaid ?? this.isPaid,
      status: status ?? this.status,
      saleDate: saleDate ?? this.saleDate,
      createdBy: createdBy ?? this.createdBy,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      products: products ?? this.products,
      tableId: tableId ?? this.tableId,
      table: table ?? this.table,
    );
  }

  // UPDATED: Format invoice number to show sequential numbers like INV-000001
  String get formattedInvoiceNumber {
    try {
      // Extract the numeric part from invoice number
      // Handle formats like: INV-20251001, INV-1, INV-0001, etc.
      String numericPart = invoiceNumber.replaceAll('INV-', '');

      // Try to parse as integer to get the sequential number
      int invoiceNum = int.tryParse(numericPart) ?? 0;

      // If it's a date format (like 20251001), use the ID instead
      if (numericPart.length == 8 && invoiceNum > 20200000) {
        // This looks like a date (YYYYMMDD), use ID for sequential number
        return 'INV-${id.toString().padLeft(6, '0')}';
      } else if (invoiceNum > 0) {
        // This is already a sequential number, format it properly
        return 'INV-${invoiceNum.toString().padLeft(6, '0')}';
      } else {
        // Fallback: use ID for sequential number
        return 'INV-${id.toString().padLeft(6, '0')}';
      }
    } catch (e) {
      // Fallback: use ID for sequential number
      return 'INV-${id.toString().padLeft(6, '0')}';
    }
  }

  // ALTERNATIVE: Simple version using just the ID
  String get formattedInvoiceNumberSimple {
    return 'INV-${id.toString().padLeft(6, '0')}';
  }

  String get creatorName {
    return createdBy['fullname']?.toString() ?? 'Unknown';
  }

  String get tableName {
    return table?['name']?.toString() ?? 'N/A';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sub_total': subTotal,
        'discount': discount,
        'grand_total': grandTotal,
        'is_paid': isPaid,
        'status': status,
        'sale_date': saleDate.toIso8601String(),
        'created_by': createdBy,
        'invoice_number': invoiceNumber,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'products': products,
        'table_id': tableId,
        'table': table,
      };
}
