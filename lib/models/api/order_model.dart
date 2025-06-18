class Order {
  final int id;
  final int tableId;
  final List<OrderItem> items;

  Order({required this.id, required this.tableId, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      tableId: json['table_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int productId;
  final int quantity;

  OrderItem({required this.productId, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }
}
