import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';

extension DishPhotoMapper on DishPhoto {
  FirestoreDishPhoto toFirestoreDishPhoto() => FirestoreDishPhoto(
    photoUrl: photoUrl,
    sortOrder: sortOrder,
    id: id,
  );
}

extension ListDishPhotoMapper on List<DishPhoto> {
  List<FirestoreDishPhoto> toFirestoreDishPhotos() => map((photo) => photo.toFirestoreDishPhoto()).toList().sorted();
}

extension FirestoreDishPhotoMapper on FirestoreDishPhoto {
  DishPhoto toDishPhoto() => DishPhoto(
      photoUrl: photoUrl,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListFirestoreDishPhotoMapper on List<FirestoreDishPhoto> {
  List<DishPhoto> toDishPhotos() => map((photo) => photo.toDishPhoto()).toList().sorted();
}
