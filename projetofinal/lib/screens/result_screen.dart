import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bill_provider.dart';
import '../providers/division_provider.dart';

class ResultScreen extends ConsumerWidget {
  final int billIndex;

  const ResultScreen({Key? key, required this.billIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = ref.watch(billsProvider)[billIndex];
    final totalAmount = ref.watch(billTotalProvider)(bill);
    final productBreakdown = ref.watch(productDivisionProvider)(bill);
    final personTotals = ref.watch(personTotalsProvider)(bill);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo Final: ${bill.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Conta Final', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    Text(
                      '€ ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Totais por Pessoa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...personTotals.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(
                    '€ ${e.value.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )),
            const SizedBox(height: 24),
            const Text('Divisão de Produtos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...productBreakdown.map((p) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Participantes: ${p['splitBetween']}'),
                        Text('Tipo: ${p['splitType'] == 'valueBased' ? 'Por Valor' : 'Por Quantidade'}'),
                      ],
                    ),
                    trailing: Text(
                      '€ ${(p['total'] ?? 0.0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
            if (bill.imagePath != null) ...[
              const SizedBox(height: 24),
              const Text('Recibo Capturado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(bill.imagePath!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Text('Erro ao carregar imagem'),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}