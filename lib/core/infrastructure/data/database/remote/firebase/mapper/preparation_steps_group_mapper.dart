import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/preparation_step_mapper.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';

extension PreparationStepsGroupMapper on PreparationStepsGroup {
  FirestorePreparationStepsGroup toFirestorePreparationStepsGroup() => FirestorePreparationStepsGroup(
    name: name,
    sortOrder: sortOrder,
    steps: steps.toFirestorePreparationSteps(),
    id: id,
  );
}

extension ListPreparationStepsGroupMapper on List<PreparationStepsGroup> {
  List<FirestorePreparationStepsGroup> toFirestorePreparationStepsGroups() => map((group) => group.toFirestorePreparationStepsGroup()).toList().sorted();
}

extension FirestorePreparationStepsGroupMapper on FirestorePreparationStepsGroup {
  PreparationStepsGroup toPreparationStepsGroup() => PreparationStepsGroup(
      name: name,
      sortOrder: sortOrder,
      steps: steps.toPreparationSteps(),
      id: id,
  );
}

extension ListFirestorePreparationStepsGroupMapper on List<FirestorePreparationStepsGroup> {
  List<PreparationStepsGroup> toPreparationStepsGroups() => map((group) => group.toPreparationStepsGroup()).toList().sorted();
}
