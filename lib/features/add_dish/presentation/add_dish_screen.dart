import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_vm.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final _permissionsManager = getIt<PermissionsManager>();
  final _imagePicker = getIt<ImagePicker>();

  List<DishPhoto> _photos = List.empty();

  @override
  void initState() {
    super.initState();

    _viewModel.photosStream.listen((photos) {
      setState(() {
        _photos = photos;
      });
    });
  }

  Future<void> onPickImageClicked() async {
    if (!(await _permissionsManager.arePhotosPermissionsGranted)) {
      showSnackBar(context, "todo");  // TODO: text as string resource
      return;
    }

    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage == null) return;
    _viewModel.onPhotoAdded(pickedImage.path);
  }

  Future<void> onCreateDishClicked() async {
    final dishName = _dishNameController.text;
    final category = _categoryController.text;
    final preparationTime = int.parse(_preparationTimeController.text);
    await _viewModel.onCreateDishClicked(
      dishName: dishName,
      preparationTimeInMinutes: preparationTime,
      category: category,
    );
  }

  @override
  void dispose() {
    //  TODO
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Add dish"),
        ), // TODO
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
                      validator: (name) => null, // TODO
                      decoration: InputDecoration(
                        hintText: "Dish name", //TODO
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
                      validator: (name) => null, // TODO
                      decoration: InputDecoration(
                        hintText: "Category", //TODO
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
                      controller: _preparationTimeController,
                      validator: (name) => null, // TODO
                      decoration: InputDecoration(
                        hintText: "Preparation time", //TODO
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
                        "Create dish",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: _photos.isEmpty
                            ? IconButton(
                                onPressed: onPickImageClicked,
                                icon: const Icon(Icons.add_a_photo),
                              )
                            : PlatformAwareImage(imagePath: _photos.first.photoUrl),
                            // : Image.network(_photos.first.photoUrl),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
