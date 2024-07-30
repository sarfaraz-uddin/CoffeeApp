class Coffee {
  final String name;
  final String price;
  final String imagePath;
  final String? category;

  Coffee({
    required this.name,
    required this.price,
    required this.imagePath,
    this.category
  });
}
