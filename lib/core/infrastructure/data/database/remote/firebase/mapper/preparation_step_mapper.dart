import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_step.dart';
import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';

extension PreparationStepMapper on PreparationStep {
  FirestorePreparationStep toFirestorePreparationStep() => FirestorePreparationStep(
      name: name,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListPreparationStepMapper on List<PreparationStep> {
  List<FirestorePreparationStep> toFirestorePreparationSteps() => map((step) => step.toFirestorePreparationStep()).toList().sorted();
}

extension FirestorePreparationStepMapper on FirestorePreparationStep {
  PreparationStep toPreparationStep() => PreparationStep(
      name: name,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListFirestorePreparationStepMapper on List<FirestorePreparationStep> {
  List<PreparationStep> toPreparationSteps() => map((step) => step.toPreparationStep()).toList().sorted();
}
