import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/dish_photo.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/platform_aware_image.dart';
import 'package:flutter/material.dart';

class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.dish, required this.onTap});

  final Dish dish;
  final void Function(Dish) onTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 9),
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueAccent,
        ),
        child: InkWell(
          onTap: () { onTap(dish); },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PhotosContainer(photos: dish.photos),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${dish.name}, ${dish.category}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _TextWithLabel(
                      iconData: Icons.timelapse_rounded,
                      text: "${dish.preparationTimeInMinutes}",
                    ),
                    const SizedBox(height: 5),
                    _TextWithLabel(
                      iconData: Icons.fastfood_rounded,
                      text: "${dish.ingredients.length}",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

class _TextWithLabel extends StatelessWidget {
  const _TextWithLabel({required this.iconData, required this.text});

  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(iconData, color: Colors.black),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
          )
        ],
      );
}

class _PhotosContainer extends StatelessWidget {
  const _PhotosContainer({required this.photos});

  final List<DishPhoto> photos;

  double get _size  => 180;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: _size,
      width: _size,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: photos.length,
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: PlatformAwareImage(
            imagePath: photos[index].photoUrl,
            height: _size,
            width: _size,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
}
