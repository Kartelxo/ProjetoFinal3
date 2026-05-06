enum ProductSplitType {
  valueBased, // Divide o valor total do produto igualmente entre as pessoas selecionadas
  quantityBased, // Permite atribuir quantidades específicas do produto a cada pessoa
}

class ProductDivisionConfig {
  final ProductSplitType splitType;
  // Para splitType.quantityBased: Map<PersonName, AssignedQuantity>
  // Para splitType.valueBased: Este mapa pode ser ignorado, ou usado para inicializar
  final Map<String, double> assignedQuantities;
  // Para splitType.valueBased: conjunto de nomes das pessoas que partilham o produto
  final Set<String> selectedParticipants;

  ProductDivisionConfig({
    this.splitType = ProductSplitType.valueBased,
    this.assignedQuantities = const {},
    this.selectedParticipants = const {},
  });

  ProductDivisionConfig copyWith({
    ProductSplitType? splitType,
    Map<String, double>? assignedQuantities,
    Set<String>? selectedParticipants,
  }) {
    return ProductDivisionConfig(
      splitType: splitType ?? this.splitType,
      assignedQuantities: assignedQuantities ?? this.assignedQuantities,
      selectedParticipants: selectedParticipants ?? this.selectedParticipants,
    );
  }
}