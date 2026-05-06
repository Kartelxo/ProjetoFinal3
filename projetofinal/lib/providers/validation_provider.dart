import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para validação do nome de uma pessoa.
/// Retorna uma mensagem de erro (String) se inválido, ou null se válido.
final personNameValidatorProvider = Provider<String? Function(String)>(
  (ref) => (String name) {
    if (name.trim().isEmpty) {
      return 'O nome não pode estar vazio.';
    }
    return null;
  },
);

/// Provider para validação do nome de um produto.
/// Retorna uma mensagem de erro (String) se inválido, ou null se válido.
final productNameValidatorProvider = Provider<String? Function(String)>(
  (ref) => (String name) {
    if (name.trim().isEmpty) {
      return 'O nome do produto não pode estar vazio.';
    }
    return null;
  },
);

/// Provider para validação do preço de um produto.
/// Retorna uma mensagem de erro (String) se inválido, ou null se válido.
final productPriceValidatorProvider = Provider<String? Function(String)>(
  (ref) => (String priceText) {
    if (priceText.trim().isEmpty) {
      return 'O preço não pode estar vazio.';
    }
    final price = double.tryParse(priceText);
    if (price == null) {
      return 'Preço inválido. Utilize números e ponto decimal.';
    }
    if (price <= 0) {
      return 'O preço deve ser maior que zero.';
    }
    return null;
  },
);

/// Provider para validação da quantidade de um produto.
/// Retorna uma mensagem de erro (String) se inválido, ou null se válido.
final productQuantityValidatorProvider = Provider<String? Function(String)>(
  (ref) => (String quantityText) {
    if (quantityText.trim().isEmpty) {
      return 'A quantidade não pode estar vazia.';
    }
    final quantity = double.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      return 'Quantidade inválida. Deve ser um número maior que zero.';
    }
    return null;
  },
);