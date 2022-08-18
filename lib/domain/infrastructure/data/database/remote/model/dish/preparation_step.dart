class PreparationStep extends Comparable<PreparationStep> {
  PreparationStep({
    required this.name,
    required this.sortOrder,
    this.id,
  });

  final String name;
  final int sortOrder;
  final String? id;

  @override
  int compareTo(PreparationStep other) => sortOrder.compareTo(other.sortOrder);
}
