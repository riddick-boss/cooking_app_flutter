import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
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

  static const double _columnGap = 20;
  
  @override
  void initState() {
    super.initState();
    _viewModel.getDish(widget.dishId);

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dishTitle),
      ),
      body: StreamBuilder<Dish?>(
        stream: _viewModel.dishStream,
        builder: (context, snapshot) {
          final dish = snapshot.data;

          if(dish == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(dish.name),
                  const SizedBox(height: _columnGap),
                  Text(dish.category),
                  const SizedBox(height: _columnGap),
                  Text(dish.preparationTimeInMinutes.toString()),
                  const SizedBox(height: _columnGap),
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      itemCount: dish.photos.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: PlatformAwareImage(
                          imagePath: dish.photos[index].photoUrl,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _columnGap),
                  ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: dish.ingredients.map((ingredient) {
                      return Row(
                        key: ValueKey(ingredient.id),
                        children: [
                          Text(ingredient.name),
                          const Spacer(),
                          Text(ingredient.quantity.orEmpty)
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: _columnGap),
                  ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: dish.preparationStepsGroups.map((group) {
                      return Column(
                        key: ValueKey(group.id),
                        children: [
                          Text(group.name),
                          ListView(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              for (final step in group.steps) Text(step.name, key: ValueKey(step.id),)
                            ],
                          )
                        ],
                      );
                    }).toList(),
                  )
                ],
              ),
            );
        },
      ),
    );
  }
}
