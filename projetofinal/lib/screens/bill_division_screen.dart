import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bill_provider.dart';
import '../providers/division_provider.dart';
import '../providers/product_division_config_provider.dart';
import '../models/product_division_config.dart';

class BillDivisionScreen extends ConsumerWidget {
  final int billIndex;

  const BillDivisionScreen({Key? key, required this.billIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billsProvider)[billIndex];

    final totalAmount = ref.watch(billTotalProvider)(bill);
    final productBreakdown = ref.watch(productDivisionProvider)(bill);
    final personTotals = ref.watch(personTotalsProvider)(bill);

    return Scaffold(
      appBar: AppBar(title: Text('Divisão da Conta - ${bill.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Produtos', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...productBreakdown.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                final total = (p['total'] ?? 0.0) as double;
                final perPerson = (p['perPerson'] ?? 0.0) as double;
                final splitBetween = p['splitBetween'] ?? '';
                return Card(
                  child: ExpansionTile(
                    title: Text(p['name'] ?? ''),
                    subtitle: Text('Total: € ${total.toStringAsFixed(2)} • Quantidade: ${bill.products[index].quantity.toStringAsFixed(0)}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dividido entre: $splitBetween'),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Text('Tipo de divisão: '),
                              const SizedBox(width: 8),
                              Consumer(builder: (context, ref, _) {
                                final config = ref.watch(productDivisionConfigProvider)[index] ?? ProductDivisionConfig();
                                return DropdownButton<ProductSplitType>(
                                  value: config.splitType,
                                  items: ProductSplitType.values
                                      .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                                      .toList(),
                                  onChanged: (t) {
                                    if (t == null) return;
                                    final newConfig = config.copyWith(splitType: t);
                                    ref.read(productDivisionConfigProvider.notifier).updateProductConfig(index, newConfig);
                                  },
                                );
                              }),
                            ]),
                            const SizedBox(height: 8),
                            Consumer(builder: (context, ref, _) {
                              final config = ref.watch(productDivisionConfigProvider)[index] ?? ProductDivisionConfig();
                              if (config.splitType == ProductSplitType.valueBased) {
                                return Column(
                                  children: bill.people.map((person) {
                                    final selected = config.selectedParticipants.contains(person.name);
                                    return CheckboxListTile(
                                      title: Text(person.name),
                                      value: selected,
                                      onChanged: (v) {
                                        final updatedSet = Set<String>.from(config.selectedParticipants);
                                        if (v == true) {
                                          updatedSet.add(person.name);
                                        } else {
                                          updatedSet.remove(person.name);
                                        }
                                        final updated = config.copyWith(selectedParticipants: updatedSet);
                                        ref.read(productDivisionConfigProvider.notifier).updateProductConfig(index, updated);
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                    );
                                  }).toList(),
                                );
                              }

                              // quantityBased
                              return Column(
                                children: bill.people.map((person) {
                                  final currentQty = config.assignedQuantities[person.name] ?? 0.0;
                                  // total assigned by others
                                  final totalAssignedExceptCurrent = config.assignedQuantities.entries
                                      .where((e) => e.key != person.name)
                                      .fold<double>(0.0, (sum, e) => sum + e.value);
                                  final productQuantity = bill.products[index].quantity.toInt();
                                  int maxAllowed = (productQuantity - totalAssignedExceptCurrent.toInt());
                                  if (maxAllowed < 0) maxAllowed = 0;
                                  int currentInt = currentQty.toInt();
                                  if (currentInt > maxAllowed) currentInt = maxAllowed;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(person.name)),
                                        SizedBox(
                                          width: 100,
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            value: currentInt,
                                            items: List<DropdownMenuItem<int>>.generate(
                                              maxAllowed + 1,
                                              (i) => DropdownMenuItem(value: i, child: Center(child: Text(i.toString()))),
                                            ),
                                            onChanged: (v) {
                                              if (v == null) return;
                                              // safety: ensure sum doesn't exceed product.quantity
                                              final newTotal = totalAssignedExceptCurrent + v;
                                              if (newTotal > productQuantity) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('A soma das unidades não pode exceder ${productQuantity}')));
                                                return;
                                              }
                                              final updated = Map<String, double>.from(config.assignedQuantities);
                                              updated[person.name] = v.toDouble();
                                              ref.read(productDivisionConfigProvider.notifier).updateProductConfig(index, config.copyWith(assignedQuantities: updated));
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('un.'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                            const SizedBox(height: 8),
                            Align(alignment: Alignment.centerRight, child: Text('Parte por pessoa: € ${perPerson.toStringAsFixed(2)}')),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 12),
              const Text('Totais por Pessoa', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...personTotals.entries.map((e) {
                return ListTile(title: Text(e.key), trailing: Text('€ ${e.value.toStringAsFixed(2)}'));
              }).toList(),
            ],
          ),
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