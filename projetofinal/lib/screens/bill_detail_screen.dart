import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/person.dart';
import '../models/product.dart';
import '../models/bill.dart';
import '../widgets/appButton.dart';
import '../providers/bill_provider.dart';

class BillDetailScreen extends ConsumerWidget {
  final int billIndex;

  const BillDetailScreen({required this.billIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billsProvider)[billIndex];

    final personNameController = TextEditingController();
    final personIdController = TextEditingController();
    final productNameController = TextEditingController();
    final productIdController = TextEditingController();
    final productPriceController = TextEditingController();
    final productQuantityController = TextEditingController();

    void addPerson() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Adicionar Pessoa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: personNameController,
                  decoration: InputDecoration(labelText: 'Nome da Pessoa'),
                ),
                TextField(
                  controller: personIdController,
                  decoration: InputDecoration(labelText: 'ID da Pessoa'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String name = personNameController.text.trim();
                  String id = personIdController.text.trim();
                  if (name.isNotEmpty && id.isNotEmpty) {
                    Person person = Person(name: name, id: id);
                    Bill updatedBill = Bill(
                      name: bill.name,
                      people: [...bill.people, person],
                      products: bill.products,
                    );
                    ref.read(billsProvider.notifier).updateBill(billIndex, updatedBill);
                    personNameController.clear();
                    personIdController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Adicionar'),
              ),
            ],
          );
        },
      );
    }

    void addProduct() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Adicionar Produto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Nome do Produto'),
                ),
                TextField(
                  controller: productIdController,
                  decoration: InputDecoration(labelText: 'ID do Produto'),
                ),
                TextField(
                  controller: productPriceController,
                  decoration: InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: productQuantityController,
                  decoration: InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String name = productNameController.text.trim();
                  String id = productIdController.text.trim();
                  double price = double.tryParse(productPriceController.text) ?? 0.0;
                  double quantity = double.tryParse(productQuantityController.text) ?? 0.0;
                  if (name.isNotEmpty && id.isNotEmpty) {
                    Product product = Product(name: name, id: id, price: price, quantity: quantity);
                    Bill updatedBill = Bill(
                      name: bill.name,
                      people: bill.people,
                      products: [...bill.products, product],
                    );
                    ref.read(billsProvider.notifier).updateBill(billIndex, updatedBill);
                    productNameController.clear();
                    productIdController.clear();
                    productPriceController.clear();
                    productQuantityController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Adicionar'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(bill.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pessoas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: bill.people.length,
                itemBuilder: (context, index) {
                  Person person = bill.people[index];
                  return ListTile(
                    title: Text('${person.name} (${person.id})'),
                  );
                },
              ),
            ),
            AppButton(onPressed: addPerson, label: 'Adicionar Pessoa'),
            SizedBox(height: 20),
            Text('Produtos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: bill.products.length,
                itemBuilder: (context, index) {
                  Product product = bill.products[index];
                  return ListTile(
                    title: Text('${product.name} (${product.id})'),
                    subtitle: Text('Preço: ${product.price}, Quantidade: ${product.quantity}'),
                  );
                },
              ),
            ),
            AppButton(onPressed: addProduct, label: 'Adicionar Produto'),
          ],
        ),
      ),
    );
  }
}