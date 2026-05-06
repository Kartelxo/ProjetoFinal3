import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill.dart';
import '../widgets/appButton.dart';
import '../providers/bill_provider.dart';
import 'bill_detail_screen.dart';

class Screen1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    final billNameController = TextEditingController();

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
                    ref.read(billsProvider.notifier).addBill(Bill(name: name));
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillDetailScreen(billIndex: index),
                        ),
                      ),
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