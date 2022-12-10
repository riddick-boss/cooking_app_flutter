import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/dish/presentation/dish_vm.dart';
import 'package:flutter/material.dart';

class DishScreen extends StatelessWidget {
  const DishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dishId = ModalRoute.of(context)!.settings.arguments! as String;
    return _Screen(dishId: dishId);
  }
}

class _Screen extends StatefulWidget {
  const _Screen({required this.dishId});

  final String dishId;

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final _viewModel = getIt<DishViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getDish(widget.dishId);

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 117, 216, 239),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder<Dish?>(
          stream: _viewModel.dishStream,
          builder: (context, snapshot) {
            final dish = snapshot.data;

            if (dish == null) {
              return const ColoredBox(
                color: Colors.lightBlueAccent,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            return Column(
              children: [
                _PhotosContainer(photos: dish.photos),
                const SizedBox(height: 25),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.lightBlue,
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _NameText(
                          key: const ValueKey("name_text"),
                          name: dish.name,
                        ),
                        _CategoryText(
                          key: const ValueKey("category_text"),
                          category: dish.category,
                        ),
                        _IngredientsList(
                          key: const ValueKey("ingredients_list"),
                          ingredients: dish.ingredients,
                        ),
                        _PreparationStepsGroupsList(
                          key: const ValueKey("preparation_steps_groups_list"),
                          groups: dish.preparationStepsGroups,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _PhotosContainer extends StatelessWidget {
  const _PhotosContainer({required this.photos});

  final List<DishPhoto> photos;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 300,
        child: PageView.builder(
          itemCount: photos.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => PlatformAwareImage(
            imagePath: photos[index].photoUrl,
            fit: BoxFit.fill,
          ),
        ),
      );
}

class _NameText extends StatelessWidget {
  const _NameText({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _CategoryText extends StatelessWidget {
  const _CategoryText({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Text(
          category,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

class _IngredientsList extends StatelessWidget {
  const _IngredientsList({super.key, required this.ingredients});

  final List<Ingredient> ingredients;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            const Text(
              AppStrings.dishIngredientsTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: ingredients
                  .map(
                    (ingredient) => Row(
                      key: ValueKey(ingredient.id),
                      children: [
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            ingredient.quantity.orEmpty,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
}

class _PreparationStepsGroupsList extends StatelessWidget {
  const _PreparationStepsGroupsList({super.key, required this.groups});

  final List<PreparationStepsGroup> groups;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            const Text(
              AppStrings.dishPreparationStepsGroupsTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: groups
                  .map(
                    (group) => Column(
                      key: ValueKey(group.id),
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        ListView(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: group.steps
                              .map(
                                (step) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.align_horizontal_right_rounded,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            step.name,
                                            key: ValueKey(step.id),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
}
