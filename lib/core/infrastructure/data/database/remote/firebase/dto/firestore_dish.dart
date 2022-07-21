import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDish {
  FirestoreDish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    this.dishId,
  });

  factory FirestoreDish.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if(data == null) throw ArgumentError("Data from firebase is null!");
    return FirestoreDish(
      dishName: data[_FirestoreDishNames.dishName] as String,
      preparationTimeInMinutes: data[_FirestoreDishNames.preparationTimeInMinutes] as int,
      category: data[_FirestoreDishNames.category] as String,
      dishId: data[_FirestoreDishNames.dishId] as String,
    );
  }

  Map<String, dynamic> toFirestore() => {
    _FirestoreDishNames.dishName: dishName,
    _FirestoreDishNames.preparationTimeInMinutes: preparationTimeInMinutes,
    _FirestoreDishNames.category: category,
  };

  final String dishName;
  final int preparationTimeInMinutes;
  final String category;
  final String? dishId;
}

class _FirestoreDishNames {
  static const dishName = 'dish_name';
  static const preparationTimeInMinutes = 'preparation_time_in_minutes';
  static const category = 'category';
  static const dishId = 'dish_id';
}
