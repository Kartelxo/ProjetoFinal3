import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/person.dart';
import '../models/product.dart';
import '../models/bill.dart';
import '../widgets/appButton.dart';
import '../providers/validation_provider.dart'; // Importar o novo provider de validação
import '../providers/bill_provider.dart';
import 'bill_division_screen.dart'; // Importar o novo ecrã

class BillDetailScreen extends ConsumerStatefulWidget {
  final int billIndex;

  const BillDetailScreen({required this.billIndex});

  @override
  ConsumerState<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends ConsumerState<BillDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
  final bill = ref.watch(billsProvider)[widget.billIndex];

    final personNameController = TextEditingController();
    final productNameController = TextEditingController();
    final productPriceController = TextEditingController();
    final productQuantityController = TextEditingController();
    final ImagePicker _picker = ImagePicker();

    Future<void> _pickFromGallery() async {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final updatedBill = Bill(
          name: bill.name,
          people: bill.people,
          products: bill.products,
          imagePath: image.path,
        );
        ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imagem selecionada: ${image.name}')));
      }
    }

    Future<void> _takePhoto() async {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final updatedBill = Bill(
          name: bill.name,
          people: bill.people,
          products: bill.products,
          imagePath: image.path,
        );
        ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Foto tirada: ${image.name}')));
      }
    }

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
                  // Usar o provider de validação
                  final validatePersonName = ref.read(personNameValidatorProvider);
                  final nameError = validatePersonName(name);

                  if (nameError == null) { // Se o nome for válido
                    Person person = Person(name: name);
                    Bill updatedBill = Bill(
                      name: bill.name,
                      people: [...bill.people, person],
                      products: bill.products,
                      imagePath: bill.imagePath,
                    );
                    ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill); // Atualizar a conta
                    personNameController.clear();
                    Navigator.of(context).pop();
                  } else {
                    // Exibir mensagem de erro (ex: SnackBar)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(nameError)));
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
                  String priceText = productPriceController.text.trim();
                  String quantityText = productQuantityController.text.trim();

                  // Usar os providers de validação
                  final validateProductName = ref.read(productNameValidatorProvider);
                  final validateProductPrice = ref.read(productPriceValidatorProvider);
                  final validateProductQuantity = ref.read(productQuantityValidatorProvider);

                  final nameError = validateProductName(name);
                  final priceError = validateProductPrice(priceText);
                  final quantityError = validateProductQuantity(quantityText);

                  if (nameError == null && priceError == null && quantityError == null) {
                    double price = double.parse(priceText); // Já validado para ser um double
                    double quantity = double.parse(quantityText); // Já validado para ser um double
                    Product product = Product(
                      name: name,
                      price: price,
                      quantity: quantity,
                    );
                    Bill updatedBill = Bill(
                      name: bill.name,
                      people: bill.people,
                      products: [...bill.products, product],
                      imagePath: bill.imagePath,
                    );
                    ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill); // Atualizar a conta
                    productNameController.clear(); // Limpar campos
                    productPriceController.clear();
                    productQuantityController.clear();
                    Navigator.of(context).pop();
                  } else {
                    // Exibir mensagens de erro combinadas
                    String errorMessage = [nameError, priceError, quantityError].whereType<String>().join('\n');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
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
                    title: Text(person.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // remove person
                        final updatedPeople = [...bill.people]..removeAt(index);
                        final updatedBill = Bill(
                          name: bill.name,
                          people: updatedPeople,
                          products: bill.products,
                          imagePath: bill.imagePath,
                        );
                        ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill);
                      },
                    ),
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
                    title: Text(product.name),
                    subtitle: Text('Preço: ${product.price}, Quantidade: ${product.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        final updatedProducts = [...bill.products]..removeAt(index);
                        final updatedBill = Bill(
                          name: bill.name,
                          people: bill.people,
                          products: updatedProducts,
                          imagePath: bill.imagePath,
                        );
                        ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill);
                      },
                    ),
                  );
                },
              ),
            ),
            AppButton(onPressed: addProduct, label: 'Adicionar Produto'),
            const SizedBox(height: 12),
            Text('Adicionar recibo(s)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: _pickFromGallery,
                    label: 'Galeria',
                    icon: Icons.photo_library,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: _takePhoto,
                    label: 'Tirar foto',
                    icon: Icons.camera_alt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bill.imagePath != null) ...[
              Row(
                children: [
                  Expanded(child: Text('Arquivo: ${bill.imagePath!.split('/').last}')),
                  TextButton(
                    onPressed: () async {
                      // Alterar -> abrir opções: gallery
                      await _pickFromGallery();
                    },
                    child: Text('Alterar'),
                  ),
                  TextButton(
                    onPressed: () {
                      final updatedBill = Bill(
                        name: bill.name,
                        people: bill.people,
                        products: bill.products,
                        imagePath: null,
                      );
                      ref.read(billsProvider.notifier).updateBill(widget.billIndex, updatedBill);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recibo apagado')));
                    },
                    child: Text('Apagar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  // Validação global da conta (2+ pessoas, 1+ produto, valores > 0)
                  final validateBill = ref.read(billValidatorProvider);
                  final error = validateBill(bill);

                  if (error == null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BillDivisionScreen(billIndex: widget.billIndex),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error), backgroundColor: Colors.red),
                    );
                  }
                },
                label: 'Finalizar e Calcular',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}