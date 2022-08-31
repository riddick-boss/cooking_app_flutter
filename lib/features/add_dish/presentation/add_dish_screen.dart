import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_vm.dart';
import 'package:flutter/material.dart';

class AddDishScreen extends StatefulWidget {
  const AddDishScreen({super.key});

  @override
  State createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dishNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _preparationTimeController = TextEditingController();

  final _viewModel = getIt<AddDishViewModel>();

  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });
  }

  Future<void> onCreateDishClicked() async {
    final dishName = _dishNameController.text.trim();
    final category = _categoryController.text.trim();
    final preparationTime = int.parse(_preparationTimeController.text);
    await _viewModel.onCreateDishClicked(
      dishName: dishName,
      preparationTimeInMinutes: preparationTime,
      category: category,
    );
  }

  @override
  void dispose() {
    _dishNameController.dispose();
    _categoryController.dispose();
    _preparationTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addDishTitle),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Expanded(
                    //   child: TextFormField(
                    TextFormField(
                      controller: _dishNameController,
                      validator: (name) => !name.isNullOrEmpty
                          ? null
                          : AppStrings.addDishNameError,
                      decoration: InputDecoration(
                        hintText: AppStrings.addDishNameHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(height: 20),
                    // Expanded(
                    //   child: TextFormField(
                    TextFormField(
                      controller: _categoryController,
                      validator: (category) => !category.isNullOrEmpty
                          ? null
                          : AppStrings.addDishCategoryError,
                      decoration: InputDecoration(
                        hintText: AppStrings.addDishCategoryHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(height: 20),
                    // Expanded(
                    //   child: TextFormField(
                    TextFormField(
                      // TODO: use picker
                      controller: _preparationTimeController,
                      validator: (time) => int.parse(time!) > 0
                          ? null
                          : AppStrings.addDishPreparationTimeError,
                      decoration: InputDecoration(
                        hintText: AppStrings.addDishPreparationTimeHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(height: 20),
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
              // StreamBuilder<List<Ingredient>>(
              //   stream: _viewModel.ingredients,
              //   builder: (context, snapshot) {
              //     final ingredients = snapshot.data;
              //     if (ingredients == null) {
              //       return const SizedBox();
              //     }
              //     return const SizedBox();
              //     // return ; TODO
              //   },
              // ),
              StreamBuilder<List<String>>(
                stream: _viewModel.photosPathsStream,
                builder: (context, snapshot) {
                  final photos = snapshot.data;
                  if (photos == null) {
                    return const SizedBox();
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
              )
            ],
          ),
        ),
      );
}
