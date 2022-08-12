import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/preparation_steps_group.dart';

import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_steps_group.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/mapper/preparation_step_mapper.dart';
import 'package:cooking_app_flutter/core/util/extension/list_extension.dart';

extension PreparationStepsGroupMapper on PreparationStepsGroup {
  FireStorePreparationStepsGroup toFirestorePreparationStepsGroup() => FireStorePreparationStepsGroup(
    name: name,
    sortOrder: sortOrder,
    steps: steps.toFirestorePreparationSteps(),
    id: id,
  );
}

extension ListPreparationStepsGroupMapper on List<PreparationStepsGroup> {
  List<FireStorePreparationStepsGroup> toFirestorePreparationStepsGroups() => map((group) => group.toFirestorePreparationStepsGroup()).toList().sorted();
}

extension FireStorePreparationStepsGroupMapper on FireStorePreparationStepsGroup {
  PreparationStepsGroup toPreparationStepsGroup() => PreparationStepsGroup(
      name: name,
      sortOrder: sortOrder,
      steps: steps.toPreparationSteps(),
      id: id,
  );
}

extension ListFireStorePreparationStepsGroupMapper on List<FireStorePreparationStepsGroup> {
  List<PreparationStepsGroup> toPreparationStepsGroups() => map((group) => group.toPreparationStepsGroup()).toList().sorted();
}
