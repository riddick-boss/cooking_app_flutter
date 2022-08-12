import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
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

  Future<void> onCreateDishClicked() async {
    final dishName = _dishNameController.text;
    final category = _categoryController.text;
    final preparationTime = int.parse(_preparationTimeController.text);
    await _viewModel.onCreateDishClicked(dishName: dishName, preparationTimeInMinutes: preparationTime, category: category);
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
          )
        ],
      ),
    ),
  );
}
