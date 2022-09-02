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
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
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

  final _newIngredientName = BehaviorSubject<String>.seeded("");
  Stream<String> get newIngredientName => _newIngredientName.stream; // TODO: needed?

  void onNewIngredientNameChanged(String value) {
    _newIngredientName.add(value);
  }

  final _newIngredientQuantity = BehaviorSubject<String?>.seeded(null);
  Stream<String?> get newIngredientQuantity => _newIngredientQuantity.stream; // TODO: needed?

  void onNewIngredientQuantityChanged(String value) {
    _newIngredientQuantity.add(value);
  }
  
  final _ingredients = BehaviorSubject<List<Ingredient>>.seeded(List.empty());
  Stream<List<Ingredient>> get ingredients => _ingredients.stream;

  final _clearNewIngredientTextFields = PublishSubject<Unit>();
  Stream<Unit> get clearNewIngredientTextFields => _clearNewIngredientTextFields.stream;

  void onAddIngredientClicked() {
    final name = _newIngredientName.value;
    final quantity = _newIngredientQuantity.value;
    if (name.isEmpty) return;
    _ingredients.addElement(Ingredient(name: name, quantity: quantity));
    _clearNewIngredientTextFields.add(Unit());
  }

  void onRemoveIngredientClicked(Ingredient ingredient) {
    _ingredients.removeElement(ingredient);
  }

  void onIngredientsReordered(int oldIdx, int newIdx) {
    final list = List<Ingredient>.from(_ingredients.value)..reorder(oldIdx, newIdx);
    _ingredients.add(list);
  }

  final _preparationStepsGroups = BehaviorSubject<Map<String, List<String>>>.seeded({});
  Stream<Map<String, List<String>>> get preparationStepsGroups => _preparationStepsGroups.stream;

  final _newPreparationStepsGroupName = BehaviorSubject<String>.seeded("");
  Stream<String> get newPreparationStepsGroupName => _newPreparationStepsGroupName.stream; // TODO: needed?

  void onNewPreparationStepsGroupNameChanged(String value) {
    _newPreparationStepsGroupName.add(value);
  }

  final _clearNewPreparationStepsGroupTextField = PublishSubject<Unit>();
  Stream<Unit> get clearNewPreparationStepsGroupTextField => _clearNewPreparationStepsGroupTextField.stream;

  void onAddPreparationStepsGroupClicked() {
    final name = _newPreparationStepsGroupName.value;
    if (name.isEmpty || _preparationStepsGroups.value.containsKey(name)) return;
    final newMap = Map<String, List<String>>.from(_preparationStepsGroups.value)..[name] = List<String>.empty();
    _preparationStepsGroups.add(newMap);
    _clearNewPreparationStepsGroupTextField.add(Unit());
  }

  void onRemovePreparationStepsGroupClicked(String key) {
    final newMap = Map<String, List<String>>.from(_preparationStepsGroups.value)..remove(key);
    _preparationStepsGroups.add(newMap);
  }

  Future<void> onCreateDishClicked({
    required String dishName,
    required int preparationTimeInMinutes,
    required String category,
  }) async {
    final prepSteps1 = [PreparationStep(name: "step2", sortOrder: 2), PreparationStep(name: "step1", sortOrder: 1)]; //TODO: del
    final prepSteps2 = [PreparationStep(name: "1step", sortOrder: 1), PreparationStep(name: "2step", sortOrder: 2)]; //TODO: del
    final group1 = PreparationStepsGroup(name: "group1", sortOrder: 1, steps: prepSteps1); //TODO: del
    final group2 = PreparationStepsGroup(name: "group2", sortOrder: 2, steps: prepSteps2); //TODO: del
    final groups = [group2, group1]; //TODO: del
    final dish = Dish(
      category: category,
      preparationTimeInMinutes: preparationTimeInMinutes,
      dishName: dishName,
      ingredients: _ingredients.value,
      preparationStepsGroups: groups, //TODO: from user
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
}
