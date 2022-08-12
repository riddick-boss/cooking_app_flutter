class FireStorePreparationStep extends Comparable<FireStorePreparationStep>{
  FireStorePreparationStep({
    required this.name,
    required this.sortOrder,
    this.id,
  });

  //TODO: factory fromFirestore

  Map<String, dynamic> toFirestore() => {
        _FirestorePreparationStepFields.name: name,
        _FirestorePreparationStepFields.sortOrder: sortOrder,
      };

  final String name;
  final int sortOrder;
  final String? id;

  @override
  int compareTo(FireStorePreparationStep other) => sortOrder.compareTo(other.sortOrder);
}

class _FirestorePreparationStepFields {
  static const name = 'name';
  static const sortOrder = 'sortOrder';
  static const id = 'id';
}
