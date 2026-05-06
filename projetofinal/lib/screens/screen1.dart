import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';
import 'bill_detail_screen.dart';

class Screen1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    final controller = TextEditingController();

    void addBill() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Adicionar Conta'),
            content: TextField(controller: controller, decoration: InputDecoration(labelText: 'Nome da Conta')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String name = controller.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(billsProvider.notifier).addBill(Bill(name: name));
                    controller.clear();
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
      body: bills.isEmpty
          ? Center(child: Text('Nenhuma conta de compra adicionada ainda.'))
          : ListView.separated(
                  itemCount: bills.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    Bill bill = bills[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => BillDetailScreen(billIndex: index))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(bill.name, style: TextStyle(fontSize: 16))),
                                Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(onPressed: addBill, label: Text('Nova Conta'), icon: Icon(Icons.add)),
    );
  }
}