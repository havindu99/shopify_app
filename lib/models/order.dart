class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Order {
  final String id;
  final String date;
  final String status;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: json['date'],
      status: json['status'],
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}
