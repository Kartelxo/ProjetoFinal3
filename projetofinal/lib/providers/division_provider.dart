import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bill.dart';
import '../models/product_division_config.dart';
import 'product_division_config_provider.dart';

/// Provider que calcula o valor total acumulado dos produtos na conta.
final billTotalProvider = Provider<double Function(Bill)>(
  (ref) => (Bill bill) {
    return bill.products.fold(
      0.0,
      (previousValue, product) => previousValue + (product.price * product.quantity),
    );
  },
);

/// Provider que calcula quanto cada pessoa deve pagar.
/// Divide o total pelo número de participantes.
final billDivisionProvider = Provider<double Function(Bill)>(
  (ref) => (Bill bill) {
    if (bill.people.isEmpty) return 0.0;

    final total = ref.read(billTotalProvider)(bill);
    return total / bill.people.length;
  },
);

/// Provider que calcula a divisão individual de cada produto por pessoa.
final productDivisionProvider = Provider<List<Map<String, dynamic>> Function(Bill)>(
  (ref) => (Bill bill) {
    final productConfigs = ref.watch(productDivisionConfigProvider);

    return bill.products.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      final config = productConfigs[index] ?? ProductDivisionConfig();

      double totalProductCost = product.price * product.quantity;
      double perPersonShareForDisplay = 0.0; // This will be for the ListTile trailing
      String splitDescription = '';

      if (config.splitType == ProductSplitType.valueBased) {
        final participants = product.personNames.isNotEmpty
            ? product.personNames
            : bill.people.map((e) => e.name).toList();
        if (participants.isNotEmpty) {
          perPersonShareForDisplay = totalProductCost / participants.length;
          splitDescription = participants.join(', ');
        } else {
          splitDescription = 'Ninguém selecionado';
        }
      } else { // ProductSplitType.quantityBased
        double totalAssignedQuantity = config.assignedQuantities.values.fold(0.0, (sum, qty) => sum + qty);
        if (totalAssignedQuantity > 0) {
          perPersonShareForDisplay = totalProductCost;
          splitDescription = config.assignedQuantities.entries
              .where((e) => e.value > 0)
              .map((e) => '${e.key} (${e.value.toStringAsFixed(0)} un.)')
              .join(', ');
        } else {
          splitDescription = 'Nenhuma quantidade atribuída';
        }
      }

      return <String, dynamic>{
        'name': product.name,
        'total': totalProductCost,
        'perPerson': perPersonShareForDisplay,
        'splitBetween': splitDescription,
        'splitType': config.splitType.name,
        'assignedQuantities': config.assignedQuantities,
      };
    }).toList();
  },
);

/// Provider que calcula o total que cada pessoa específica deve pagar.
final personTotalsProvider = Provider<Map<String, double> Function(Bill)>(
  (ref) => (Bill bill) {
    final totals = <String, double>{};
    for (var person in bill.people) {
      totals[person.name] = 0.0;
    }

    final productConfigs = ref.watch(productDivisionConfigProvider);

    for (int i = 0; i < bill.products.length; i++) {
      final product = bill.products[i];
      final config = productConfigs[i] ?? ProductDivisionConfig();
      double pricePerUnit = product.price;

      if (config.splitType == ProductSplitType.valueBased) {
        final participants = product.personNames.isNotEmpty
            ? product.personNames
            : bill.people.map((e) => e.name).toList();
        
        if (participants.isEmpty) continue;
        
        final share = (product.price * product.quantity) / participants.length;
        for (var name in participants) {
          if (totals.containsKey(name)) {
            totals[name] = totals[name]! + share;
          }
        }
      } else { // ProductSplitType.quantityBased
        for (var entry in config.assignedQuantities.entries) {
          final personName = entry.key;
          final assignedQty = entry.value;
          if (totals.containsKey(personName)) {
            totals[personName] = totals[personName]! + (assignedQty * pricePerUnit);
          }
        }
      }
    }
    return totals;
  },
);