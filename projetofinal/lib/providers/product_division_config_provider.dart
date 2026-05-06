import 'package:riverpod/riverpod.dart';
import '../models/bill.dart';
import '../models/product_division_config.dart';

/// Provider que gere a configuração de divisão para cada produto.
/// A chave do mapa é o nome do produto.
final productDivisionConfigProvider = NotifierProvider<ProductDivisionConfigNotifier, Map<int, ProductDivisionConfig>>(() {
  return ProductDivisionConfigNotifier();
});

class ProductDivisionConfigNotifier extends Notifier<Map<int, ProductDivisionConfig>> {
  @override
  Map<int, ProductDivisionConfig> build() {
    // Estado inicial vazio
    return {};
  }

  /// Inicializa as configurações de divisão para todos os produtos de uma conta.
  void initializeConfig(Bill bill) {
    final newConfig = Map<int, ProductDivisionConfig>.from(state);
    bool changed = false;

    for (int i = 0; i < bill.products.length; i++) {
      // Usa o índice como chave para garantir a unicidade
      if (!newConfig.containsKey(i)) {
        newConfig[i] = ProductDivisionConfig(
          splitType: ProductSplitType.valueBased,
          assignedQuantities: {},
        );
        changed = true;
      }
    }
    
    if (changed) state = newConfig;
  }

  /// Atualiza a configuração de divisão para um produto específico.
  void updateProductConfig(int productIndex, ProductDivisionConfig config) {
    final newState = Map<int, ProductDivisionConfig>.from(state);
    newState[productIndex] = config;
    state = newState;
  }
}