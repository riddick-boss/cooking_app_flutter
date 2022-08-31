import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_step.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';
import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:cooking_app_flutter/domain/util/extension/behavior_subject_list_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

@injectable
class AddDishViewModel {
  final _dbManager = getIt<RemoteDatabaseManager>();
  final _permissionsManager = getIt<PermissionsManager>();
  final _imagePicker = getIt<ImagePicker>();

  final _showSnackBarSubject = PublishSubject<String>();
  Stream<String> get showSnackBarStream => _showSnackBarSubject.stream;

  final _photosPaths = BehaviorSubject<List<String>>.seeded(List.empty());
  Stream<List<String>> get photosPathsStream => _photosPaths.stream;

  List<DishPhoto> _createDishPhotosList(List<String> photosPaths) => photosPaths
      .mapIndexed((index, path) => DishPhoto(photoUrl: path, sortOrder: index))
      .toList(growable: false);

  Future<void> onPickPhotoClicked() async {
    if (!(await _permissionsManager.arePhotosPermissionsGranted)) {
      _showSnackBarSubject.add(AppStrings.addDishPermissionsDeniedSnackBarMessage);
      return;
    }

    final pickedPhoto = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedPhoto == null) return;
    _photosPaths.addElement(pickedPhoto.path);
  }

  void onRemovePhotoClicked(String path) {
    _photosPaths.removeElement(path);
  }

  final _ingredients = BehaviorSubject<List<Ingredient>>.seeded(List.empty());
  Stream<List<Ingredient>> get ingredients => _ingredients.stream;

  void onAddIngredientClicked(String name, String? quantity) {
    if (name.isEmpty) return;
    _ingredients.addElement(Ingredient(name: name, quantity: quantity));
  }

  void onRemoveIngredientClicked(Ingredient ingredient) {
    _ingredients.removeElement(ingredient);
  }

  Future<void> onCreateDishClicked({
    required String dishName,
    required int preparationTimeInMinutes,
    required String category,
  }) async {
    final ingredient1 = Ingredient(name: "name1", quantity: "quantity1"); //TODO: del
    final ingredient2 = Ingredient(name: "name2"); // TODO: del
    final prepSteps1 = [PreparationStep(name: "step2", sortOrder: 2), PreparationStep(name: "step1", sortOrder: 1)]; //TODO: del
    final prepSteps2 = [PreparationStep(name: "1step", sortOrder: 1), PreparationStep(name: "2step", sortOrder: 2)]; //TODO: del
    final group1 = PreparationStepsGroup(name: "group1", sortOrder: 1, steps: prepSteps1); //TODO: del
    final group2 = PreparationStepsGroup(name: "group2", sortOrder: 2, steps: prepSteps2); //TODO: del
    final groups = [group2, group1]; //TODO: del
    final dish = Dish(
      category: category,
      preparationTimeInMinutes: preparationTimeInMinutes,
      dishName: dishName,
      // ingredients: [ingredient1, ingredient2], //TODO: from user
      ingredients: _ingredients.value,
      preparationStepsGroups: groups,
      //TODO: from user
      photos: _createDishPhotosList(_photosPaths.value),
    );
    try {
      await _dbManager.createDish(dish);
      // TODO: show info to user
    } catch (e) {
      debugPrint("error during dish creation: $e");
      //TODO: show  info to user
    }
  }

// Future<void> onCreateDishClicked({
//   required String dishName,
//   required int preparationTimeInMinutes,
//   required String category,
// }) async {
//   final dish = Dish(
//       category: category,
//       preparationTimeInMinutes: preparationTimeInMinutes,
//       dishName: dishName,
//       ingredients: [], //TODO
//   );
//   try {
//     await _dbManager.createDish(dish);
//     // TODO: show info to user
//   } catch(e) {
//     debugPrint("error during dish creation: $e");
//     //TODO: show  info to user
//   }
// }
}
