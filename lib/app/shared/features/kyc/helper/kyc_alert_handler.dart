import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';
import '../notifier/kyc/kyc_notipod.dart';
import '../view/components/choose_documents/choose_documents.dart';
import '../view/components/kyc_verify_your_profile/kyc_verify_your_profile.dart';
import '../view/popup/show_kyc_popup.dart';

class Kyc {
  static void verify({
    required Reader read,
    required void Function()
        onVerified, // navigate if kycStatus allow or allowWithAlert
    required TriggerAction trigger,
  }) {
    final status = _statusFromTrigger(read, trigger);

    if (status == KycStatus.allowed.toInt) {
      onVerified();
    } else if (status == KycStatus.allowedWithKycAlert.toInt) {
      _handleAllowedWithAlert(onVerified, read);
    } else {
      _handle(status, onVerified, read);
    }




    // if (trigger == TriggerAction.deposit) {
    //   _handleStatus(status, onVerified);
    // } else if (trigger == TriggerAction.sell) {
    //
    // } else {
    //
    // }

    // if (trigger == KycStatus.allowed.toInt) {
    //   onVerified();
    // } else if (status == KycStatus.allowedWithKycAlert.toInt) {
    //   _handleAllowedWithAlert(onVerified);
    // } else if () {
    //   // we are verifying
    // } else {
    //   Kyc.handle(read);
    // }
  }

  // static void _handle(
  //   int status,
  //   Function() onVerified,
  //   Reader read,
  // ) {
  //   if (status == KycStatus.allowed.toInt) {
  //     onVerified();
  //   } else if (status == KycStatus.allowedWithKycAlert.toInt) {
  //     _handleAllowedWithAlert(onVerified, read);
  //   }
  // }

  static void _handleAllowedWithAlert(
    Function() onVerified,
    Reader read,
  ) {
    _showAllowedWithAlert(
      kycVerified,
      read,
      onVerified,
      false,
    );
  }

  static int _statusFromTrigger(Reader read, TriggerAction trigger) {
    final kycState = read(kycNotipod);

    if (trigger == TriggerAction.deposit) {
      return kycState.depositStatus;
    } else if (trigger == TriggerAction.sell) {
      return kycState.sellStatus;
    } else {
      return kycState.withdrawalStatus;
    }
  }

// handles internal KYC flow
//   static void handle(Reader read) {
//     // we are verifying
//     if (status == KycStatus.isRequired.toInt()) {
//       _handleIsRequired(kycVerified);
//     } else if (status == KycStatus.inProgress.toInt()) {
//       _handleInProgress();
//     } else {
//       _handleBlocked();
//     }
//   }

  static void _handle({
    bool navigatePop = false,
    required Function() currentNavigate,
    required int status,
    required KycModel kycVerified,
    required bool isProgress,
  }) {
    if (isProgress) {
      _showVerifyingAlert();
      return;
    }

    if (status == kycOperationStatus(KycOperationStatus.kycRequired)) {
      _showKycRequiredAlert(
        kycVerified,
      );
    } else if (status == kycOperationStatus(KycOperationStatus.kycInProgress)) {
      _showVerifyingAlert();
    } else if (status ==
        kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
      _showAllowedWithAlert(
        kycVerified,
        currentNavigate,
        navigatePop,
      );
    } else {
      _showBlockedAlert();
    }
  }

  void _showKycRequiredAlert(
    KycModel kycVerified,
  ) {
    showKycPopup(
      context: context,
      imageAsset: verifyYourProfileAsset,
      primaryText: 'Verify your profile!',
      secondaryText: 'To complete profile verification you\n'
          'need to pass following steps:',
      primaryButtonName: 'Continue',
      secondaryButtonName: 'Later',
      activePrimaryButton: kycVerified.requiredVerifications.isNotEmpty,
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        _navigateVerifiedNavigate(
          kycVerified.requiredVerifications,
          kycVerified.requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        Navigator.pop(context);
      },
      child: _showDocuments(kycVerified.requiredVerifications),
    );
  }

  void _showVerifyingAlert() {
    showKycPopup(
      context: context,
      imageAsset: verifyingNowAsset,
      primaryText: 'We’re verifying now',
      secondaryText: 'You’ll be notified after we’ve\n'
          'completed the process. Usually within\n'
          'a few minutes.',
      primaryButtonName: 'Done',
      onPrimaryButtonTap: () {
        Navigator.pop(context);
      },
    );
  }

  static void _showAllowedWithAlert(
    KycModel kycVerified,
    Function() currentNavigat,
    bool navigatePop,
    BuildContext context,
  ) {
    showKycPopup(
      context: context,
      imageAsset: verifyYourProfileAsset,
      primaryText: 'Verify your profile!',
      secondaryText: 'To complete profile verification you '
          'need to pass following steps:',
      primaryButtonName: 'Continue',
      secondaryButtonName: 'Later',
      onPrimaryButtonTap: () {
        Navigator.pop(context);
        _navigateVerifiedNavigate(
          kycVerified.requiredVerifications,
          kycVerified.requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        _navigateTo(currentNavigat, navigatePop);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_showDocuments(kycVerified.requiredVerifications)],
      ),
    );
  }

  void _showBlockedAlert() {
    showKycPopup(
      context: context,
      primaryText: 'You’re blocked!',
      secondaryText: 'Please contact support to unblock\nyour account',
      primaryButtonName: 'Support',
      onPrimaryButtonTap: () {
        Navigator.pop(context);
      },
    );
  }

  static void _navigateVerifiedNavigate(
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> documents,
  ) {
    if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
      SetPhoneNumber.push(
        context: context,
        successText: '2-Factor verification enabled',
        then: () => KycVerifyYourProfile.push(
          context: context,
          requiredVerifications: requiredVerifications,
        ),
      );
    } else {
      ChooseDocuments.push(
        context: context,
        headerTitle: stringRequiredVerified(requiredVerifications.first),
        documents: documents,
      );
    }
  }

  void _navigateTo(Function() currentNavigate, bool navigatePop) {
    if (navigatePop) {
      Navigator.of(context).pop();
    }
    currentNavigate();
  }

  Widget _showDocuments(List<RequiredVerified> requiredVerifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        ..._listRequiredVerification(requiredVerifications),
        const SpaceH36(),
      ],
    );
  }

  Widget _documentText(String title, int textNumber) {
    if (textNumber == 0) {
      return Baseline(
        baseline: 37.0,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          '${textNumber + 1}. $title',
          style: sBodyText1Style.copyWith(
            color: colors.grey1,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          const SpaceH17(),
          Text(
            '${textNumber + 1}. $title',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ],
      );
    }
  }

  List<Widget> _listRequiredVerification(
    List<RequiredVerified> requiredVerifications,
  ) {
    final requiredVerified = <Widget>[];

    for (var i = 0; i < requiredVerifications.length; i++) {
      if (requiredVerifications[i] == RequiredVerified.proofOfIdentity) {
        requiredVerified.add(
          _documentText('Verify your identity', i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfAddress) {
        requiredVerified.add(
          _documentText('Address verification', i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfFunds) {
        requiredVerified.add(
          _documentText('Proof source of funds', i),
        );
      } else if (requiredVerifications[i] == RequiredVerified.proofOfPhone) {
        requiredVerified.add(
          _documentText('Secure your account', i),
        );
      }
    }

    return requiredVerified;
  }
}
