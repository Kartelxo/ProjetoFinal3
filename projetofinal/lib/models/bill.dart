import 'person.dart';
import 'product.dart';

class Bill {
  final String name;
  final Person? person;
  final List<Product>? products;

  Bill({required this.name, this.person, this.products});
}