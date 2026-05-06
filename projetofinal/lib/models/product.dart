class Product {
  final String name;
  final double price;
  final double quantity;
  final List<String> personNames; // Nomes das pessoas que dividem este produto (if valueBased)

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    this.personNames = const [],
  });
}