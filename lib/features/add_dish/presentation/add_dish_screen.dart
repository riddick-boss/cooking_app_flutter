import 'package:bottom_picker/bottom_picker.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/domain/util/unit.dart';
import 'package:cooking_app_flutter/features/add_dish/data/dish_upload_status.dart';
import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final _viewModel = getIt<AddDishViewModel>();

  static const double _columnGap = 20;

  @override
  void initState() {
    super.initState();

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });

    _viewModel.progressIndicatorStatus.listen((event) {
      switch (event) {
        case null:
          {
            EasyLoading.dismiss();
            break;
          }
        case DishUploadStatus.uploading:
          {
            EasyLoading.show(status: AppStrings.addDishUploading);
            break;
          }
        case DishUploadStatus.success:
          {
            EasyLoading.showSuccess(AppStrings.easyLoadingSuccess);
            break;
          }
        case DishUploadStatus.failure:
          {
            EasyLoading.showError(AppStrings.easyLoadingFailure);
            break;
          }
      }
    });
    
    _viewModel.navigateToDishesList.listen((event) {
      MainAppNav.navigator.currentState?.pop();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.lightBlue[800],
        appBar: AppBar(
          title: const Text(AppStrings.addDishTitle),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.yellow,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _DishTextField(
                controller: _viewModel.dishNameController,
                label: AppStrings.addDishNameHint,
              ),
              const SizedBox(height: _columnGap),
              _DishTextField(
                controller: _viewModel.categoryController,
                label: AppStrings.addDishCategoryHint,
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<int>(
                stream: _viewModel.preparationTime,
                builder: (context, snapshot) => _PreparationTimeRow(
                  time: snapshot.data ?? 0,
                  onTimeChange: _viewModel.onPreparationTimeChanged,
                  context: context,
                ),
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<List<Ingredient>>(
                stream: _viewModel.ingredients,
                builder: (context, snapshot) => _IngredientsList(
                  ingredients: snapshot.data,
                  onListReordered: _viewModel.onIngredientsReordered,
                  onRemoveIngredientClicked:
                      _viewModel.onRemoveIngredientClicked,
                ),
              ),
              _AddIngredientRow(
                nameController: _viewModel.ingredientNameController,
                quantityController: _viewModel.ingredientQuantityController,
                onAddIngredientClicked: _viewModel.onAddIngredientClicked,
              ),
              const SizedBox(height: _columnGap),
              const _PreparationStepsGroupsHeader(),
              const SizedBox(height: _columnGap),
              StreamBuilder<Map<String, List<String>>>(
                stream: _viewModel.preparationStepsGroups,
                builder: (context, snapshot) => _PreparationStepsGroupsList(
                  preparationStepsGroups: snapshot.data,
                  stepsChanged: _viewModel.stepsChanged,
                  onPreparationStepsReordered:
                      _viewModel.onPreparationStepsReordered,
                  onPreparationStepRemoved:
                      _viewModel.onRemovePreparationStepClicked,
                  onAddPreparationStepClicked:
                      _viewModel.onAddPreparationStepClicked,
                ),
              ),
              const SizedBox(height: _columnGap),
              _AddPreparationStepGroupRow(
                controller: _viewModel.newPreparationStepsGroupNameController,
                onAddPreparationStepsGroupAddClicked:
                    _viewModel.onAddPreparationStepsGroupClicked,
              ),
              const SizedBox(height: _columnGap),
              StreamBuilder<List<String>>(
                stream: _viewModel.photosPathsStream,
                builder: (context, snapshot) => _PhotosContainer(
                  photosPaths: snapshot.data,
                  onPickPhotoClicked: _viewModel.onPickPhotoClicked,
                ),
              ),
              const SizedBox(height: _columnGap),
              _AddDishButton(
                onCreateDishClicked: _viewModel.onCreateDishClicked,
              ),
            ],
          ),
        ),
      );
}

class _DishTextField extends StatelessWidget {
  const _DishTextField({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      );
}

class _PreparationTimeRow extends StatelessWidget {
  const _PreparationTimeRow({
    required this.time,
    required this.onTimeChange,
    required this.context,
  });

  final BuildContext context;
  final int time;
  final void Function(dynamic) onTimeChange;

  static const int _preparationTimeMaxRange = 500;

  void _showTimePicker() {
    BottomPicker(
      title: AppStrings.addDishPreparationTimeHint,
      titleStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      items: List<Text>.generate(
        _preparationTimeMaxRange,
        (i) => Text(
          "$i",
          textAlign: TextAlign.center,
        ),
      ),
      dismissable: true,
      buttonText: AppStrings.addDishSubmitPreparationTimeButton,
      selectedItemIndex: time,
      onSubmit: onTimeChange,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.addDishPreparationTime(time),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          InkWell(
            onTap: _showTimePicker,
            child: const Icon(Icons.edit),
          )
        ],
      );
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({
    required this.ingredients,
    required this.onListReordered,
    required this.onRemoveIngredientClicked,
  });

  final List<Ingredient>? ingredients;
  final void Function(int oldIdx, int newIdx) onListReordered;
  final void Function(Ingredient) onRemoveIngredientClicked;

  @override
  Widget build(BuildContext context) {
    if (ingredients == null) {
      return const Text(
        AppStrings.addDishIngredientsHeader,
        style: TextStyle(fontSize: 20),
      );
    }

    return ReorderableListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      onReorder: onListReordered,
      header: const Text(
        AppStrings.addDishIngredientsHeader,
        style: TextStyle(fontSize: 20),
      ),
      children: <Widget>[
        for (final ingredient in ingredients!)
          ListTile(
            focusColor: Colors.yellow,
            key: UniqueKey(),
            title: Text(ingredient.name),
            subtitle: ingredient.quantity.isNullOrEmpty
                ? null
                : Text(ingredient.quantity!),
            trailing: IconButton(
              onPressed: () {
                onRemoveIngredientClicked(ingredient);
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
            ),
          )
      ],
    );
  }
}

class _AddIngredientRow extends StatelessWidget {
  const _AddIngredientRow({
    required this.nameController,
    required this.quantityController,
    required this.onAddIngredientClicked,
  });

  final TextEditingController nameController;
  final TextEditingController quantityController;
  final void Function() onAddIngredientClicked;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.addDishIngredientNameLabel,
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.addDishIngredientQuantityLabel,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onAddIngredientClicked,
            icon: const Icon(Icons.add),
          )
        ],
      );
}

class _PreparationStepsGroupsHeader extends StatelessWidget {
  const _PreparationStepsGroupsHeader();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: double.infinity,
        child: Text(
          AppStrings.addDishPreparationStepsGroupsHeader,
          style: TextStyle(fontSize: 20),
        ),
      );
}

class _PreparationStepsGroupsList extends StatelessWidget {
  const _PreparationStepsGroupsList({
    required this.preparationStepsGroups,
    required this.stepsChanged,
    required this.onPreparationStepsReordered,
    required this.onPreparationStepRemoved,
    required this.onAddPreparationStepClicked,
  });

  final Map<String, List<String>>? preparationStepsGroups;
  final Stream<Unit> stepsChanged;
  final void Function(String groupName, int oldIdx, int newIdx)
      onPreparationStepsReordered;
  final void Function(String, String) onPreparationStepRemoved;
  final void Function(String groupName, String stepName)
      onAddPreparationStepClicked;

  @override
  Widget build(BuildContext context) {
    if (preparationStepsGroups == null) {
      return const SizedBox(height: 0);
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: preparationStepsGroups!.entries.map((entry) {
        final groupName = entry.key;
        final steps = entry.value;
        return Column(
          children: [
            StreamBuilder<Unit>(
              stream: stepsChanged,
              builder: (context, snapshot) {
                return ReorderableListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  header: Text(
                    groupName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  onReorder: (oldIdx, newIdx) {
                    onPreparationStepsReordered(groupName, oldIdx, newIdx);
                  },
                  children: [
                    for (final step in steps)
                      ListTile(
                        key: UniqueKey(),
                        title: Text(step),
                        trailing: IconButton(
                          onPressed: () {
                            onPreparationStepRemoved(groupName, step);
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
            _AddPreparationStepRow(
              groupName: groupName,
              onAddClicked: onAddPreparationStepClicked,
            ),
            const SizedBox(height: 15),
          ],
        );
      }).toList(),
    );
  }
}

class _AddPreparationStepRow extends StatefulWidget {
  const _AddPreparationStepRow({
    required this.groupName,
    required this.onAddClicked,
  });

  final String groupName;
  final void Function(String groupName, String stepName) onAddClicked;

  @override
  State<_AddPreparationStepRow> createState() => _AddPreparationStepRowState();
}

class _AddPreparationStepRowState extends State<_AddPreparationStepRow> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: AppStrings.addDishStepLabel,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onAddClicked(
              widget.groupName,
              controller.text,
            );
            controller.clear();
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}

class _AddPreparationStepGroupRow extends StatelessWidget {
  const _AddPreparationStepGroupRow({
    required this.controller,
    required this.onAddPreparationStepsGroupAddClicked,
  });

  final TextEditingController controller;
  final void Function() onAddPreparationStepsGroupAddClicked;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: AppStrings.addDishStepsGroupNameLabel,
              ),
            ),
          ),
          IconButton(
            onPressed: onAddPreparationStepsGroupAddClicked,
            icon: const Icon(Icons.add),
          )
        ],
      );
}

class _PhotosContainer extends StatefulWidget {
  const _PhotosContainer({
    required this.photosPaths,
    required this.onPickPhotoClicked,
  });

  final List<String>? photosPaths;
  final void Function() onPickPhotoClicked;

  @override
  State<_PhotosContainer> createState() => _PhotosContainerState();
}

class _PhotosContainerState extends State<_PhotosContainer> {
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.photosPaths == null) {
      return const SizedBox(
        height: 0,
      );
    }
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: widget.photosPaths!.length + 1, // + 1 for add button
        controller: PageController(viewportFraction: 0.75),
        onPageChanged: (int i) => setState(() {
          _currentPhotoIndex = i;
        }),
        itemBuilder: (context, index) => Transform.scale(
          scale: index == _currentPhotoIndex ? 1 : 0.9,
          child: Card(
            color: Colors.blueAccent,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: index == widget.photosPaths!.length
                ? IconButton(
                    onPressed: widget.onPickPhotoClicked,
                    icon: const Icon(Icons.add_a_photo),
                  )
                : PlatformAwareImage(
                    imagePath: widget.photosPaths![index],
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}

class _AddDishButton extends StatelessWidget {
  const _AddDishButton({required this.onCreateDishClicked});

  final void Function() onCreateDishClicked;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onCreateDishClicked,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
        backgroundColor: Colors.yellowAccent,
      ),
      child: const Text(
        AppStrings.addDishCreateButton,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
