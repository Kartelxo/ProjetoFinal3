import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bill_provider.dart';
import '../providers/division_provider.dart';
import '../models/product_division_config.dart';
import '../providers/product_division_config_provider.dart';
class BillDivisionScreen extends ConsumerWidget {
  final int billIndex;

  const BillDivisionScreen({Key? key, required this.billIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billsProvider)[billIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDivisionConfigProvider.notifier).initializeConfig(bill);
    });

    final totalAmount = ref.watch(billTotalProvider)(bill);
    final productBreakdown = ref.watch(productDivisionProvider)(bill);
    final personTotals = ref.watch(personTotalsProvider)(bill);

    return Scaffold(
      appBar: AppBar(title: const Text('Divisão da Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Total Geral:', '€${totalAmount.toStringAsFixed(2)}', isBold: true),
                    const Divider(),
                    const Text('Resumo por Pessoa:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...personTotals.entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: _buildSummaryRow(entry.key, '€${entry.value.toStringAsFixed(2)}'),
                    )).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Divisão por Produto:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: bill.products.length, // Iterate through actual products
                itemBuilder: (context, index) {
                  final product = bill.products[index];
                  final itemBreakdown = productBreakdown.firstWhere(
                    (element) => element['name'] == product.name, // Ainda usa o nome para a exibição do breakdown
                    orElse: () => <String, dynamic>{'total': 0.0, 'perPerson': 0.0, 'splitBetween': 'Carregando...'},
                  );
                  final productConfig = ref.watch(productDivisionConfigProvider)[index] ?? ProductDivisionConfig();
                  return ExpansionTile(
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Total: €${itemBreakdown['total'].toStringAsFixed(2)}\n'
                      'Dividido por: ${itemBreakdown['splitBetween']}',
                    ),
                    trailing: productConfig.splitType == ProductSplitType.valueBased 
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('€${itemBreakdown['perPerson'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              const Text('por pessoa', style: TextStyle(fontSize: 10)),
                            ],
                          )
                        : null, // No simple 'per person' for quantity based in trailing
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ref.read(productDivisionConfigProvider.notifier).updateProductConfig(
                                  index,
                                  productConfig.copyWith(
                                    splitType: ProductSplitType.valueBased,
                                    assignedQuantities: {},
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: productConfig.splitType == ProductSplitType.valueBased
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: const Text('Dividir Valor', style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final initialAssignedQuantities = <String, double>{};
                                for (var person in bill.people) {
                                  initialAssignedQuantities[person.name] = 0.0;
                                }
                                ref.read(productDivisionConfigProvider.notifier).updateProductConfig(
                                  index,
                                  productConfig.copyWith(
                                    splitType: ProductSplitType.quantityBased,
                                    assignedQuantities: initialAssignedQuantities,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: productConfig.splitType == ProductSplitType.quantityBased
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: const Text('Dividir Quantidade', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      if (productConfig.splitType == ProductSplitType.quantityBased)
                        ...bill.people.map((person) {
                          final currentQty = productConfig.assignedQuantities[person.name] ?? 0.0;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(person.name)),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    initialValue: currentQty > 0 ? currentQty.toStringAsFixed(0) : '0',
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                    ),
                                    onChanged: (value) {
                                      final newQty = double.tryParse(value) ?? 0.0;
                                      final updatedAssignedQuantities = Map<String, double>.from(productConfig.assignedQuantities);
                                      updatedAssignedQuantities[person.name] = newQty;
                                      ref.read(productDivisionConfigProvider.notifier).updateProductConfig(
                                        index,
                                        productConfig.copyWith(assignedQuantities: updatedAssignedQuantities),
                                      );
                                    },
                                  ),
                                ),
                                const Text(' un.'),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? color}) {
    final style = TextStyle(
      fontSize: isBold ? 18 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}