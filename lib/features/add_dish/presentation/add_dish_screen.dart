import 'package:bottom_picker/bottom_picker.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_vm.dart';
import 'package:flutter/material.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> { // TODO: separate screen to smaller widgets
  final _dishNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _stepsGroupNameController = TextEditingController();

  final _viewModel = getIt<AddDishViewModel>();

  int _currentPhotoIndex = 0;

  static const int _preparationTimeMaxRange = 500;
  final _preparationTimeRange = List<Text>.generate(_preparationTimeMaxRange, (i) => Text("$i"));

  static const double _columnGap = 20;

  @override
  void initState() {
    super.initState();

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });

    _viewModel.clearNewIngredientTextFields.listen((event) {
      _ingredientNameController.clear();
      _ingredientQuantityController.clear();
    });

    _viewModel.clearNewPreparationStepsGroupTextField.listen((event) {
      _stepsGroupNameController.clear();
    });
  }

  void onCreateDishClicked() {
    _viewModel.onCreateDishClicked();
  }

  @override
  void dispose() {
    _dishNameController.dispose();
    _categoryController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    _stepsGroupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addDishTitle),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _dishNameController,
                onChanged: _viewModel.onDishNameChanged,
                decoration: const InputDecoration(labelText: AppStrings.addDishNameHint),
              ),
              const SizedBox(height: _columnGap),
              TextField(
                controller: _categoryController,
                onChanged: _viewModel.onDishCategoryChanged,
                decoration: const InputDecoration(labelText: AppStrings.addDishCategoryHint),
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<int>(
                  stream: _viewModel.preparationTime,
                  builder: (context, snapshot) {
                    final time = snapshot.data ?? 0;
                    return GestureDetector(
                      onTap: () {
                        BottomPicker(
                          title: AppStrings.addDishPreparationTimeHint,
                          titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:  15),
                          items: _preparationTimeRange,
                          dismissable: true,
                          selectedItemIndex: time,
                          onSubmit: _viewModel.onPreparationTimeChanged,
                        ).show(context);
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text(AppStrings.addDishPreparationTime(time))),
                          const Icon(Icons.edit),
                        ],
                      ),
                    );
                  },
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<List<Ingredient>>(
                stream: _viewModel.ingredients,
                builder: (context, snapshot) {
                  final ingredients = snapshot.data;
                  if (ingredients == null) {
                    return const Text(AppStrings.addDishIngredientsHeader);
                  }
                  return ReorderableListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      onReorder: _viewModel.onIngredientsReordered,
                      header: const Text(AppStrings.addDishIngredientsHeader),
                      children: <Widget>[
                        for(final ingredient in ingredients)
                          ListTile(
                            key: ValueKey(ingredient.hashCode),
                            title: Text(ingredient.name),
                            subtitle: ingredient.quantity.isNullOrEmpty
                              ? null
                             : Text(ingredient.quantity!),
                            trailing: IconButton(onPressed: () { _viewModel.onRemoveIngredientClicked(ingredient); }, icon: const Icon(Icons.remove)),
                          )
                      ],
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _ingredientNameController,
                          onChanged: _viewModel.onNewIngredientNameChanged,
                          decoration: const InputDecoration(labelText: AppStrings.addDishIngredientNameLabel),
                        ),
                        TextField(
                          controller: _ingredientQuantityController,
                          onChanged: _viewModel.onNewIngredientQuantityChanged,
                          decoration: const InputDecoration(labelText: AppStrings.addDishIngredientQuantityLabel),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: _viewModel.onAddIngredientClicked, icon: const Icon(Icons.add))
                ],
              ),
              const SizedBox(height: _columnGap),
              const SizedBox(
                  width: double.infinity,
                  child: Text(AppStrings.addDishPreparationStepsGroupsHeader),
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<Map<String, List<String>>>(
                stream: _viewModel.preparationStepsGroups,
                builder: (context, snapshot) {
                  final preparationStepsGroups = snapshot.data;
                  if (preparationStepsGroups == null) {
                    return const SizedBox(height: 0);
                  }
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: preparationStepsGroups.entries.map((entry) {
                      final groupName = entry.key;
                      final steps = entry.value;
                      return Column(
                        children: [
                          StreamBuilder<Unit>(
                            stream: _viewModel.stepsChanged,
                            builder: (context, snapshot) {
                              return ReorderableListView(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  header: Text(groupName),
                                  onReorder: (oldIdx, newIdx) {
                                    _viewModel.onPreparationStepsReordered(groupName, oldIdx, newIdx);
                                  },
                                  children: [
                                    for(final step in steps)
                                      ListTile(
                                        key: ValueKey(step.hashCode),
                                        title: Text(step),
                                        trailing: IconButton(onPressed: () { _viewModel.onPreparationStepRemoved(groupName, step); }, icon: const Icon(Icons.remove)),
                                      )
                                  ],
                              );
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: _viewModel.onNewPreparationStepNameChanged,
                                  decoration: const InputDecoration(labelText: AppStrings.addDishStepLabel),
                                ),
                              ),
                              IconButton(onPressed: () { _viewModel.onPreparationStepAdded(groupName); }, icon: const Icon(Icons.add))
                            ],
                          ),
                          const SizedBox(height: _columnGap,)
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stepsGroupNameController,
                      onChanged: _viewModel.onNewPreparationStepsGroupNameChanged,
                      decoration: const InputDecoration(labelText: AppStrings.addDishStepsGroupNameLabel),
                    ),
                  ),
                  IconButton(onPressed: _viewModel.onAddPreparationStepsGroupClicked, icon: const Icon(Icons.add))
                ],
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<List<String>>(
                stream: _viewModel.photosPathsStream,
                builder: (context, snapshot) {
                  final photos = snapshot.data;
                  if (photos == null) {
                    return const SizedBox(height: 0,);
                  }
                  return SizedBox(
                    height: 400,
                    child: PageView.builder(
                      itemCount: photos.length + 1, // + 1 for add button
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int i) => setState(() {
                        _currentPhotoIndex = i;
                      }),
                      itemBuilder: (context, index) => Transform.scale(
                        scale: index == _currentPhotoIndex ? 1 : 0.9,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: index == photos.length
                              ? IconButton(
                                  onPressed: _viewModel.onPickPhotoClicked,
                                  icon: const Icon(Icons.add_a_photo),
                                )
                              : PlatformAwareImage(imagePath: photos[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: _columnGap),
              ElevatedButton(
                onPressed: onCreateDishClicked,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                ),
                child: const Text(
                  AppStrings.addDishCreateButton,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
