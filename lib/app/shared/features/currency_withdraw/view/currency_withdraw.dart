import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/components/text_fields/app_text_field.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../models/currency_model.dart';
import '../notifier/withdrawal_address_notifier/address_validation_union.dart';
import '../notifier/withdrawal_address_notifier/withdrawal_address_notipod.dart';
import 'components/withdrawal_address_validator.dart';
import 'components/withdrawal_field_suffix/withdrawal_field_suffix.dart';
import 'screens/withdrawal_amount.dart';

/// FLOW: WithdrawalAmount -> WithdrawalPreview -> WithdrawalConfirm
class CurrencyWithdraw extends HookWidget {
  const CurrencyWithdraw({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(withdrawalAddressNotipod(currency));
    final notifier = useProvider(withdrawalAddressNotipod(currency).notifier);

    return PageFrame(
      header: 'Withdraw ${currency.description} (${currency.symbol})',
      onBackButton: () => Navigator.pop(context),
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          const SpaceH40(),
          AppTextField(
            header: 'Enter ${currency.symbol} address',
            hintText: 'Paste or scan',
            fontSize: 25.sp,
            focusNode: state.addressFocus,
            controller: state.addressController,
            onChanged: (value) => notifier.updateAddress(value),
            suffixIcon: WithdrawalFieldSuffix(
              showErase: state.showAddressErase,
              showEmptyField: state.showAddressEmptyField,
              onErase: () => notifier.eraseAddress(),
              onPaste: () => notifier.pasteAddress(),
              onScanQr: () => notifier.scanAddressQr(context),
            ),
          ),
          const SpaceH10(),
          WithdrawalAddressValidator(
            symbol: currency.symbol,
            validation: state.validation,
          ),
          if (currency.tagType != TagType.none) ...[
            const SpaceH40(),
            AppTextField(
              header: 'Enter Tag',
              hintText: 'Paste or scan',
              fontSize: 25.sp,
              focusNode: state.tagFocus,
              controller: state.tagController,
              onChanged: (value) => notifier.updateTag(value),
              suffixIcon: WithdrawalFieldSuffix(
                showErase: state.showTagErase,
                showEmptyField: state.showTagEmptyField,
                onErase: () => notifier.eraseTag(),
                onPaste: () => notifier.pasteTag(),
                onScanQr: () => notifier.scanTagQr(context),
              ),
            ),
            const SpaceH10(),
            WithdrawalAddressValidator(
              withTag: true,
              symbol: currency.symbol,
              validation: state.validation,
            ),
          ],
          const SpaceH20(),
          Text(
            'Instead of typing in an address, we recommend '
            'pasting an address or scanning a QR code.',
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Next',
            active: state.validation is Valid,
            onTap: () {
              if (state.validation is Valid) {
                navigatorPush(
                  context,
                  WithdrawalAmount(
                    currency: currency,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
