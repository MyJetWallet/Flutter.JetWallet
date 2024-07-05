import 'package:flutter/material.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/models/modify_required_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:mobx/mobx.dart';

part 'kyc_steps_store.g.dart';

class KycStepsStore extends _KycStepsStoreBase with _$KycStepsStore {
  KycStepsStore(super.reqifications);
}

abstract class _KycStepsStoreBase with Store {
  _KycStepsStoreBase(this.reqifications) {
    final modifyRequiredVerified = <ModifyRequiredVerified>[];

    for (var i = 0; i < reqifications.length; i++) {
      if (reqifications[i] == RequiredVerified.proofOfPhone) {
        modifyRequiredVerified.add(
          ModifyRequiredVerified(
            requiredVerified: reqifications[i],
            verifiedDone: true,
          ),
        );
      } else {
        modifyRequiredVerified.add(
          ModifyRequiredVerified(
            requiredVerified: reqifications[i],
          ),
        );
      }
    }

    requiredVerifications = ObservableList.of(modifyRequiredVerified);
  }

  List<RequiredVerified> reqifications;

  @observable
  ObservableList<ModifyRequiredVerified> requiredVerifications = ObservableList.of([]);

  @action
  int getVerifyComplete() {
    return requiredVerifications.isNotEmpty ? requiredVerifications.where((element) => element.verifiedDone).length : 0;
  }

  // TODO fix bug here (Bad state, no element)
  @action
  String chooseDocumentsHeaderTitle(BuildContext context) {
    final element = requiredVerifications.firstWhere((element) => !element.verifiedDone);

    return stringRequiredVerified(
      element.requiredVerified!,
    );
  }
}
