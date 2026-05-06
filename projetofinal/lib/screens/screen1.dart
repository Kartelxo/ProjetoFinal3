import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../widgets/appButton.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<Bill> bills = [];

  final TextEditingController billNameController = TextEditingController();

  void addBill() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Conta'),
          content: TextField(
            controller: billNameController,
            decoration: InputDecoration(labelText: 'Nome da Conta'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String name = billNameController.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    bills.add(Bill(name: name));
                  });
                  billNameController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contas de Compras')),
      body: Stack(
        children: [
          bills.isEmpty
              ? Center(child: Text('Nenhuma conta de compra adicionada ainda.'))
              : ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    Bill bill = bills[index];
                    return ListTile(
                      title: Text(bill.name),
                    );
                  },
                ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: AppButton(onPressed: addBill, label: 'Adicionar Conta'),
          ),
        ],
      ),
    );
  }
}