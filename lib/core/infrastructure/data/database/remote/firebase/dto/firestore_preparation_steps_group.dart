import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';

class FirestorePreparationStepsGroup extends Comparable<FirestorePreparationStepsGroup> {
  FirestorePreparationStepsGroup({
    required this.name,
    required this.sortOrder,
    required this.steps,
    this.id,
  });

  factory FirestorePreparationStepsGroup.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required List<FirestorePreparationStep> steps,
  }) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Data from firebase is null!");
    return FirestorePreparationStepsGroup(
        name: data[_FirestorePreparationStepsGroupFields.name] as String,
        sortOrder: data[_FirestorePreparationStepsGroupFields.sortOrder] as int,
        steps: steps,
        id: snapshot.id,
    );
  }

  Map<String, dynamic> toFirestore() => {
    _FirestorePreparationStepsGroupFields.name: name,
    _FirestorePreparationStepsGroupFields.sortOrder: sortOrder,
  };

  final String name;
  final int sortOrder;
  final List<FirestorePreparationStep> steps;
  final String? id;

  @override
  int compareTo(FirestorePreparationStepsGroup other) => sortOrder.compareTo(other.sortOrder);
}

class _FirestorePreparationStepsGroupFields {
  static const name = 'name';
  static const sortOrder = 'sortOrder';
}
