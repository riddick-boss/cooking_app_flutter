import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';

class FireStorePreparationStepsGroup extends Comparable<FireStorePreparationStepsGroup> {
  FireStorePreparationStepsGroup({
    required this.name,
    required this.sortOrder,
    required this.steps,
    this.id,
  });

  factory FireStorePreparationStepsGroup.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required List<FireStorePreparationStep> steps,
  }) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Data from firebase is null!");
    return FireStorePreparationStepsGroup(
        name: data[_FireStorePreparationStepsGroupFields.name] as String,
        sortOrder: data[_FireStorePreparationStepsGroupFields.sortOrder] as int,
        steps: steps,
        id: snapshot.id,
    );
  }

  Map<String, dynamic> toFireStore() => {
    _FireStorePreparationStepsGroupFields.name: name,
    _FireStorePreparationStepsGroupFields.sortOrder: sortOrder,
  };

  final String name;
  final int sortOrder;
  final List<FireStorePreparationStep> steps;
  final String? id;

  @override
  int compareTo(FireStorePreparationStepsGroup other) => sortOrder.compareTo(other.sortOrder);
}

class _FireStorePreparationStepsGroupFields {
  static const name = 'name';
  static const sortOrder = 'sortOrder';
}
