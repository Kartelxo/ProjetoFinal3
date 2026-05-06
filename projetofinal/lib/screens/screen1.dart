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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma conta adicionada ainda.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: bills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                Bill bill = bills[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.description, color: Colors.blue.shade800),
                      ),
                      title: Text(bill.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      subtitle: Text('${bill.people.length} pessoas • ${bill.products.length} produtos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => BillDetailScreen(billIndex: index))),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(onPressed: addBill, label: Text('Nova Conta'), icon: Icon(Icons.add)),
    );
  }
}