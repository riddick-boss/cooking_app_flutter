import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePreparationStep extends Comparable<FirestorePreparationStep>{
  FirestorePreparationStep({
    required this.name,
    required this.sortOrder,
    this.id,
  });

  factory FirestorePreparationStep.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Data from firebase is null!");
    return FirestorePreparationStep(
      name: data[_FirestorePreparationStepFields.name] as String,
      sortOrder: data[_FirestorePreparationStepFields.sortOrder] as int,
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() => {
        _FirestorePreparationStepFields.name: name,
        _FirestorePreparationStepFields.sortOrder: sortOrder,
      };

  final String name;
  final int sortOrder;
  final String? id;

  @override
  int compareTo(FirestorePreparationStep other) => sortOrder.compareTo(other.sortOrder);
}

class _FirestorePreparationStepFields {
  static const name = 'name';
  static const sortOrder = 'sortOrder';
}
