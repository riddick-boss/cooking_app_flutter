import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/dishes_vm.dart';
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                for(final dish in dishes)
                  GestureDetector( // TODO: as separate widget
                    key: ValueKey(dish.dishId!),
                    onTap: () { onDishClicked(dish.dishId!); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(dish.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          _PhotosContainer(photos: dish.photos),
                        ],
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

class _PhotosContainer extends StatelessWidget { // TODO: rename?
  const _PhotosContainer({required this.photos});

  final List<DishPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return SizedBox( // TODO
      height: 300,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: photos.length,
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PlatformAwareImage(
            imagePath: photos[index].photoUrl,
          ),
        ),
      ),
    );
  }
}
