import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../actions/action_deposit/action_deposit.dart';
import '../../actions/action_sell/action_sell.dart';
import '../../actions/action_withdraw/action_withdraw.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';
import '../view/components/kyc_verify_your_profile/kyc_verify_your_profile.dart';
import '../view/popup/show_kyc_popup.dart';

class KycAlertHandler {
  KycAlertHandler({
    required this.context,
    required this.colors,
  });

  final BuildContext context;
  final SimpleColors colors;

  void handle(
    int status,
    KycVerifiedModel kycVerified,
    KycStatusType statusType,
  ) {
    if (status == kycOperationStatus(KycOperationStatus.kycRequired)) {
      _showKycRequiredAlert(
        kycVerified,
      );
    } else if (status == kycOperationStatus(KycOperationStatus.kycInProgress)) {
      _showVerifyingAlert();
    } else if (status == kycOperationStatus(KycOperationStatus.allowed)) {
      _navigateTo(statusType);
    } else if (status ==
        kycOperationStatus(KycOperationStatus.allowedWithKycAlert)) {
      _showAllowedWithAlert(kycVerified, statusType);
    } else {
      _showBlockedAlert();
    }
  }

  void _showKycRequiredAlert(
    KycVerifiedModel kycVerified,
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

  void _showAllowedWithAlert(
    KycVerifiedModel kycVerified,
    KycStatusType statusType,
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
        _navigateVerifiedNavigate(
          kycVerified.requiredVerifications,
          kycVerified.requiredDocuments,
        );
      },
      onSecondaryButtonTap: () {
        _navigateTo(statusType);
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

  void _navigateVerifiedNavigate(
    List<RequiredVerified> requiredVerifications,
    List<KycDocumentType> documents,
  ) {
    if (requiredVerifications.contains(RequiredVerified.proofOfPhone)) {
      SetPhoneNumber.push(
        context: context,
        successText: '2-Factor verification enabled',
        then: () => KycVerifyYourProfile.pushReplacement(
          context: context,
          requiredVerifications: requiredVerifications,
          documents: documents,
        ),
      );
    } else {
      KycVerifyYourProfile.pushReplacement(
        context: context,
        requiredVerifications: requiredVerifications,
        documents: documents,
      );
    }
  }

  void _navigateTo(KycStatusType statusType) {
    switch (statusType) {
      case KycStatusType.deposit:
        showDepositAction(context);
        return;
      case KycStatusType.withdrawal:
        showWithdrawAction(context);
        return;
      case KycStatusType.sell:
        showSellAction(context);
        return;
    }
  }

  Widget _showDocuments(List<RequiredVerified> requiredVerifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        ..._listRequiredVerification(requiredVerifications),
        const SpaceH30(),
      ],
    );
  }

  Widget _documentText(String title, int textNumber) {
    return Baseline(
      baseline: 40.0,
      baselineType: TextBaseline.alphabetic,
      child: Text(
        '${textNumber + 1}. $title',
        style: sBodyText1Style.copyWith(
          color: colors.grey1,
        ),
      ),
    );
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
