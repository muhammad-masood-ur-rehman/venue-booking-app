class Option {
  final String category;
  final String price;
  final Map<String, dynamic> amenities;

  Option({
    required this.category,
    required this.price,
    required this.amenities,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      category: json['category'] as String,
      price: json['price'] as String,
      amenities: Map<String, dynamic>.from(json['amenities'] as Map),
    );
  }
}
