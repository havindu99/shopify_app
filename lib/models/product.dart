class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String image;
  final List<String> images;
  final String description;
  final bool inStock;
  final String? badge;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.images,
    required this.description,
    required this.inStock,
    this.badge,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      image: json['image'],
      images: List<String>.from(json['images']),
      description: json['description'],
      inStock: json['inStock'],
      badge: json['badge'],
    );
  }

  double get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();
}
