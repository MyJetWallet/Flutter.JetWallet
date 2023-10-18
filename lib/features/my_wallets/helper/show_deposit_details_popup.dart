import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:simple_kit/simple_kit.dart';

void showDepositDetails(
  BuildContext context,
  VoidCallback onClose,
) {
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.wallet_deposit_details,
    ),
    onDissmis: onClose,
    children: [
      const SpaceH12(),
      const IbanTermsContainer(),
      const SpaceH8(),
      IBanItem(
        name: intl.iban_benificiary,
        text: sSignalRModules.bankingProfileData?.simple?.account?.bankName ?? '',
      ),
      IBanItem(
        name: intl.iban_iban,
        text: sSignalRModules.bankingProfileData?.simple?.account?.iban ?? '',
      ),
      IBanItem(
        name: intl.iban_bic,
        text: sSignalRModules.bankingProfileData?.simple?.account?.bic ?? '',
      ),
      IBanItem(
        name: intl.iban_address,
        text: sSignalRModules.bankingProfileData?.simple?.account?.address ?? '',
      ),
      const SpaceH42(),
    ],
  );
}
