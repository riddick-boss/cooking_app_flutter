class Dish {
  // final List<String> ingredient TODO

  Dish({
    required this.dishName,
    required this.preparationTimeInMinutes,
    required this.category,
    this.dishId,
  });

  final String dishName;
  final int preparationTimeInMinutes;
  final String category;
  final String? dishId;
}
