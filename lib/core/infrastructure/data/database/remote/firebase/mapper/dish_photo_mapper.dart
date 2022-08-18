import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';

extension DishPhotoMapper on DishPhoto {
  FireStoreDishPhoto toFireStoreDishPhoto() => FireStoreDishPhoto(
    photoUrl: photoUrl,
    sortOrder: sortOrder,
    id: id,
  );
}

extension ListDishPhotoMapper on List<DishPhoto> {
  List<FireStoreDishPhoto> toFireStoreDishPhotos() => map((photo) => photo.toFireStoreDishPhoto()).toList().sorted();
}

extension FireStoreDishPhotoMapper on FireStoreDishPhoto {
  DishPhoto toDishPhoto() => DishPhoto(
      photoUrl: photoUrl,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListFireStoreDishPhotoMapper on List<FireStoreDishPhoto> {
  List<DishPhoto> toDishPhotos() => map((photo) => photo.toDishPhoto()).toList().sorted();
}
