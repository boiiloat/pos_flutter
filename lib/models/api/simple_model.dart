// lib/models/Simple.dart
class Simple {
  final String itemName;
  final double cost;
  final int qtyOrdered;
  final int onHold;
  final int onHand;
  final int sold;
  final int adjustment;
  final double price;
  final String balance;

  Simple({
    required this.itemName,
    required this.cost,
    required this.qtyOrdered,
    required this.onHold,
    required this.onHand,
    required this.sold,
    required this.adjustment,
    required this.price,
    required this.balance,
  });
}
