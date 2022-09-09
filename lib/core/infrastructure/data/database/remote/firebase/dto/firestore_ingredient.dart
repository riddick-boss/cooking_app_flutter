import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreIngredient {
  FirestoreIngredient({
    required this.name,
    required this.quantity,
    this.id,
  });

  factory FirestoreIngredient.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    // SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw ArgumentError("Ingredients data from firebase is null!");
    return FirestoreIngredient(
      name: data[_FirestoreIngredientFields.name] as String,
      quantity: data[_FirestoreIngredientFields.quantity] as String?,
      id: data[_FirestoreIngredientFields.id] as String,
    );
  }

  Map<String, dynamic> toFirestore() => {
        _FirestoreIngredientFields.name: name,
        _FirestoreIngredientFields.quantity: quantity,
      };

  final String name;
  final String? quantity;
  final String? id;
}

class _FirestoreIngredientFields {
  static const name = 'name';
  static const quantity = 'quantity';
  static const id = 'id';
}
