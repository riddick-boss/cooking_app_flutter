import 'package:cooking_app_flutter/core/domain/data/database/remote/model/dish/preparation_step.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/dto/firestore_preparation_step.dart';
import 'package:cooking_app_flutter/core/util/extension/list_extension.dart';

extension PreparationStepMapper on PreparationStep {
  FireStorePreparationStep toFirestorePreparationStep() => FireStorePreparationStep(
      name: name,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListPreparationStepMapper on List<PreparationStep> {
  List<FireStorePreparationStep> toFirestorePreparationSteps() => map((step) => step.toFirestorePreparationStep()).toList().sorted();
}

extension FirestorePreparationStepMapper on FireStorePreparationStep {
  PreparationStep toPreparationStep() => PreparationStep(
      name: name,
      sortOrder: sortOrder,
      id: id,
  );
}

extension ListFirestorePreparationStepMapper on List<FireStorePreparationStep> {
  List<PreparationStep> toPreparationSteps() => map((step) => step.toPreparationStep()).toList().sorted();
}
