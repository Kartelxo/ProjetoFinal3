import 'person.dart';
import 'product.dart';

class Bill {
  final String name;
  final List<Person> people;
  final List<Product> products;

  Bill({required this.name, List<Person>? people, List<Product>? products})
      : people = people ?? [],
        products = products ?? [];
}
