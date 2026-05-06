enum ProductSplitType {
  valueBased, // Divide o valor total do produto igualmente entre as pessoas selecionadas
  quantityBased, // Permite atribuir quantidades específicas do produto a cada pessoa
}

class ProductDivisionConfig {
  final ProductSplitType splitType;
  // Para splitType.quantityBased: Map<PersonName, AssignedQuantity>
  // Para splitType.valueBased: Este mapa pode ser ignorado, ou usado para inicializar
  final Map<String, double> assignedQuantities;

  ProductDivisionConfig({
    this.splitType = ProductSplitType.valueBased,
    this.assignedQuantities = const {},
  });

  ProductDivisionConfig copyWith({
    ProductSplitType? splitType,
    Map<String, double>? assignedQuantities,
  }) {
    return ProductDivisionConfig(
      splitType: splitType ?? this.splitType,
      assignedQuantities: assignedQuantities ?? this.assignedQuantities,
    );
  }
}