import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/dishes_vm.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/widget/dish_card.dart';
import 'package:flutter/material.dart';

class DishesScreen extends StatefulWidget {
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  final _viewModel = getIt<DishesViewModel>();

  void onDishClicked(String dishId) {
    MainAppNav.navigator.currentState?.pushNamed(MainAppNavDestinations.userDish.route, arguments: dishId);
  }

  @override
  void initState() {
    super.initState();
    _viewModel.getDishes();

    _viewModel.showSnackBarStream.listen((message) {
      showSnackBar(context, message);
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RefreshIndicator(
        backgroundColor: Colors.deepOrange,
        onRefresh: _viewModel.refreshDishes,
        child: StreamBuilder<List<Dish>>(
          stream: _viewModel.dishesStream,
          builder: (context, snapshot) {
            final dishes = snapshot.data ?? List.empty();

            if(dishes.isEmpty) { // TODO: what in case of exception?
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics().applyTo(const BouncingScrollPhysics()),
                clipBehavior: Clip.antiAlias,
                children: [
                  for(final dish in dishes)
                    DishCard(key: ValueKey(dish.dishId!), dish: dish, onTap: (e) { onDishClicked(e.dishId!); })
                ],
            );
          },
        ),
      ),
    );
}
