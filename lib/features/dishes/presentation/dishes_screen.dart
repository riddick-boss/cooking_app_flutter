import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/dishes_vm.dart';
import 'package:flutter/material.dart';

class DishesScreen extends StatefulWidget {
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  final _viewModel = getIt<DishesViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<List<Dish>>(
        stream: _viewModel.dishesStream,
        builder: (context, snapshot) {
          final dishes = snapshot.data ?? List.empty();

          if(dishes.isEmpty) { // TODO: what in case of exception?
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListWheelScrollView(
              physics: const BouncingScrollPhysics(),
              itemExtent: 500,
              diameterRatio: 10,
              squeeze: 0.9,
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                for(final dish in dishes)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                              "${dish.dishName}, ${dish.category}, time: ${dish.preparationTimeInMinutes}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "ingredients: ${dish.ingredients.length}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        for(final group in dish.preparationStepsGroups)
                          Center(
                            child: Text(
                              "group: ${group.name}: ${group.steps.length}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        Center(
                          child: Text(
                            "photos: ${dish.photos.length}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox( // TODO: horizontal scroll
                          height: 400,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for(final photo in dish.photos)
                                PlatformAwareImage(imagePath: photo.photoUrl)
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 400,
                        //   child: PageView.builder(
                        //       itemCount: dish.photos.length,
                        //       controller: PageController(),
                        //       itemBuilder: (context, index) => Card(
                        //         elevation: 0,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         child: PlatformAwareImage(imagePath: dish.photos[index].photoUrl),
                        //       ),
                        //   ),
                        // )
                      ],
                    ),
                  )
              ],
          );
        },
      ),
    );
  }
}
