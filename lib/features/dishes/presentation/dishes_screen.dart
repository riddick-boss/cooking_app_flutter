import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
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

          if(dishes.isEmpty) { // TODO: in case of exception
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListWheelScrollView(
              physics: const BouncingScrollPhysics(),
              itemExtent: 120,
              diameterRatio: 1.5,
              squeeze: 0.9,
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                for(final dish in dishes)
                  Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                          "${dish.dishName}, ${dish.category}, time: ${dish.preparationTimeInMinutes}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  )
              ],
          );
        },
      ),
    );
  }
}
