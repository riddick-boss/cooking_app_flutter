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
import 'package:cooking_app_flutter/domain/util/cast.dart';
import 'package:cooking_app_flutter/domain/util/extension/behavior_subject_list_extension.dart';
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:cooking_app_flutter/features/add_dish/data/dish_upload_status.dart';
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

  //name
  final _dishName = BehaviorSubject<String>.seeded('');

  Stream<String> get dishName => _dishName.stream;

  final dishNameController = TextEditingController();

  //category
  final categoryController = TextEditingController();

  //preparationTime
  final _preparationTime = BehaviorSubject<int>.seeded(0);

  Stream<int> get preparationTime => _preparationTime.stream;

  void onPreparationTimeChanged(dynamic value) {
    final time = cast<int?>(value);
    if (time == null || time < 0) return;
    _preparationTime.add(time);
  }

  //photos
  final _photosPaths = BehaviorSubject<List<String>>.seeded(List.empty());

  Stream<List<String>> get photosPathsStream => _photosPaths.stream;

  List<DishPhoto> _createDishPhotosList(List<String> photosPaths) => photosPaths
      .mapIndexed((index, path) => DishPhoto(photoUrl: path, sortOrder: index))
      .toList(growable: false);

  Future<void> onPickPhotoClicked() async {
    if (!(await _permissionsManager.arePhotosPermissionsGranted)) {
      _showSnackBarSubject
          .add(AppStrings.addDishPermissionsDeniedSnackBarMessage);
      return;
    }

    final pickedPhoto =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedPhoto == null) return;
    _photosPaths.addElement(pickedPhoto.path);
  }

  void onRemovePhotoClicked(String path) {
    _photosPaths.removeElement(path);
  }

  //ingredients
  final _ingredients = BehaviorSubject<List<Ingredient>>.seeded(List.empty());

  Stream<List<Ingredient>> get ingredients => _ingredients.stream;

  final ingredientNameController = TextEditingController();

  final ingredientQuantityController = TextEditingController();

  void onAddIngredientClicked() {
    final name = ingredientNameController.text;
    if (name.isEmpty) return;
    String? quantity = ingredientQuantityController.text;
    if (quantity.isEmpty) quantity = null;
    _ingredients.addElement(
      Ingredient(name: ingredientNameController.text, quantity: quantity),
    );
    ingredientNameController.clear();
    ingredientQuantityController.clear();
  }

  void onRemoveIngredientClicked(Ingredient ingredient) {
    _ingredients.removeElement(ingredient);
  }

  void onIngredientsReordered(int oldIdx, int newIdx) {
    final list = List<Ingredient>.from(_ingredients.value)
      ..reorder(oldIdx, newIdx);
    _ingredients.add(list);
  }

  //preparation steps
  final _preparationStepsGroups =
      BehaviorSubject<Map<String, List<String>>>.seeded({});

  Stream<Map<String, List<String>>> get preparationStepsGroups =>
      _preparationStepsGroups.stream;

  final newPreparationStepsGroupNameController = TextEditingController();

  void onAddPreparationStepsGroupClicked() {
    final name = newPreparationStepsGroupNameController.text;
    if (name.isEmpty || _preparationStepsGroups.value.containsKey(name)) return;
    final newMap = Map<String, List<String>>.from(_preparationStepsGroups.value)
      ..[name] = List<String>.empty();
    _preparationStepsGroups.add(newMap);
    newPreparationStepsGroupNameController.clear();
  }

  void onRemovePreparationStepsGroupClicked(String key) {
    final newMap = Map<String, List<String>>.from(_preparationStepsGroups.value)
      ..remove(key);
    _preparationStepsGroups.add(newMap);
  }

  final _stepsChanged = PublishSubject<Unit>();

  Stream<Unit> get stepsChanged => _stepsChanged.stream;

  void onAddPreparationStepClicked(String groupName, String step) {
    final steps = _preparationStepsGroups.value[groupName];
    if (steps == null) return;
    final newSteps = List<String>.from(steps)..add(step);
    final groups = Map<String, List<String>>.from(_preparationStepsGroups.value)
      ..[groupName] = newSteps;
    _preparationStepsGroups.add(groups);
    _stepsChanged.add(Unit());
  }

  void onPreparationStepsReordered(String groupName, int oldIdx, int newIdx) {
    final steps = _preparationStepsGroups.value[groupName];
    if (steps == null || steps.isEmpty) return;
    final newSteps = List<String>.from(steps)..reorder(oldIdx, newIdx);
    final groups = Map<String, List<String>>.from(_preparationStepsGroups.value)
      ..[groupName] = newSteps;
    _preparationStepsGroups.add(groups);
    _stepsChanged.add(Unit());
  }

  void onRemovePreparationStepClicked(String groupName, String step) {
    final steps = _preparationStepsGroups.value[groupName];
    if (steps == null) return;
    final newSteps = List<String>.from(steps)..remove(step);
    final groups = Map<String, List<String>>.from(_preparationStepsGroups.value)
      ..[groupName] = newSteps;
    _preparationStepsGroups.add(groups);
    _stepsChanged.add(Unit());
  }

  List<PreparationStepsGroup> _createPreparationStepsGroups() {
    final groups = List<PreparationStepsGroup>.empty(growable: true);
    var sortOrder = 0;
    _preparationStepsGroups.value.forEach((groupName, stepsNames) {
      final steps = _createPreparationSteps(stepsNames);
      final group = PreparationStepsGroup(
        name: groupName,
        sortOrder: sortOrder,
        steps: steps,
      );
      groups.add(group);
      sortOrder++;
    });
    return groups;
  }

  List<PreparationStep> _createPreparationSteps(List<String> stepsNames) =>
      stepsNames
          .mapIndexed(
            (index, name) => PreparationStep(name: name, sortOrder: index),
          )
          .toList();

  //progress indicator
  final _progressIndicatorStatus =
      BehaviorSubject<DishUploadStatus?>.seeded(null);

  Stream<DishUploadStatus?> get progressIndicatorStatus =>
      _progressIndicatorStatus.stream;

  Future<void> _showProgressStatusAndDismiss(DishUploadStatus status) async {
    _progressIndicatorStatus.add(status);
    await Future.delayed(const Duration(seconds: 4), () {});
    _progressIndicatorStatus.add(null);
  }

  final _navigateToDishesList = BehaviorSubject<Unit>();
  Stream<Unit> get navigateToDishesList => _navigateToDishesList.stream;

  //create dish
  Future<void> onCreateDishClicked() async {
    final dish = Dish(
      category: categoryController.text,
      preparationTimeInMinutes: _preparationTime.value,
      name: dishNameController.text,
      ingredients: _ingredients.value,
      preparationStepsGroups: _createPreparationStepsGroups(),
      photos: _createDishPhotosList(_photosPaths.value),
    );
    _progressIndicatorStatus.add(DishUploadStatus.uploading);
    try {
      await _dbManager.createDish(dish);
      await _showProgressStatusAndDismiss(DishUploadStatus.success);
      _navigateToDishesList.add(Unit());
    } catch (e) {
      await _showProgressStatusAndDismiss(DishUploadStatus.failure);
      _showSnackBarSubject
          .add(AppStrings.addDishCreationFailureSnackBarMessage);
    }
  }

  //dispose
  void dispose() {
    dishNameController.dispose();
    categoryController.dispose();
    ingredientNameController.dispose();
    ingredientQuantityController.dispose();
    newPreparationStepsGroupNameController.dispose();
  }
}
