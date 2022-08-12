import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/preparation_step.dart';

class PreparationStepsGroup extends Comparable<PreparationStepsGroup> {
  PreparationStepsGroup({
    required this.name,
    required this.sortOrder,
    required this.steps,
    this.id,
  });

  final String name;
  final int sortOrder;
  final List<PreparationStep> steps;
  final String? id;

  @override
  int compareTo(PreparationStepsGroup other) => sortOrder.compareTo(other.sortOrder);
}
