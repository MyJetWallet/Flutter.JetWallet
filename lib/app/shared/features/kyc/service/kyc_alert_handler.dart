import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../actions/action_deposit/action_deposit.dart';
import '../../actions/action_sell/action_sell.dart';
import '../../actions/action_withdraw/action_withdraw.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import '../model/kyc_operation_status_model.dart';
import '../model/kyc_verified_model.dart';
import '../view/popup/show_kyc_popup.dart';

class KycAlertHandler {
  KycAlertHandler(this.context, this.colors);

  final BuildContext context;
  final SimpleColors colors;

  // Check on deposit
  void handleDeposit(
    int depositStatus,
    KycVerifiedModel kycVerified,
  ) {
    _checkKycOperationStatus(
      depositStatus,
      kycVerified,
      KycStatusType.deposit,
    );
  }

  // Check on withdrawal
  void handleWithdrawal(
    int withdrawalStatus,
    KycVerifiedModel kycVerified,
  ) {
    _checkKycOperationStatus(
      withdrawalStatus,
      kycVerified,
      KycStatusType.withdrawal,
    );
  }

  // Check on trade
  void handleSell(
    int tradeStatus,
    KycVerifiedModel kycVerified,
  ) {
    _checkKycOperationStatus(
      tradeStatus,
      kycVerified,
      KycStatusType.sell,
    );
  }

  void _checkKycOperationStatus(
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
        SetPhoneNumber.pushReplacement(
          context: context,
          successText: 'New phone number confirmed',
        );
      },
      onSecondaryButtonTap: () {
        Navigator.pop(context);
      },
      child: _showDocuments(kycVerified.requiredDocuments),
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
        SetPhoneNumber.pushReplacement(
          context: context,
          successText: 'New phone number confirmed',
        );
      },
      onSecondaryButtonTap: () {
        _navigateTo(statusType);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_showDocuments(kycVerified.requiredDocuments)],
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

  Widget _showDocuments(List<KycDocumentType> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        ..._listRequiredDocuments(documents),
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

  List<Widget> _listRequiredDocuments(List<KycDocumentType> documents) {
    final requiredDocuments = <Widget>[];
    for (var i = 0; i < documents.length; i++) {
      if (documents[i] == KycDocumentType.governmentId) {
        requiredDocuments.add(
          _documentText('GovernmentId', i),
        );
      } else if (documents[i] == KycDocumentType.passport) {
        requiredDocuments.add(
          _documentText('Passport', i),
        );
      } else if (documents[i] == KycDocumentType.driverLicense) {
        requiredDocuments.add(
          _documentText('DriverLicense', i),
        );
      } else if (documents[i] == KycDocumentType.residentPermit) {
        requiredDocuments.add(
          _documentText('ResidentPermit', i),
        );
      } else if (documents[i] == KycDocumentType.selfieImage) {
        requiredDocuments.add(
          _documentText('SelfieImage', i),
        );
      } else if (documents[i] == KycDocumentType.addressDocument) {
        requiredDocuments.add(
          _documentText('AddressDocument', i),
        );
      } else if (documents[i] == KycDocumentType.financialDocument) {
        requiredDocuments.add(
          _documentText('FinancialDocument', i),
        );
      }
    }

    return requiredDocuments;
  }
}
