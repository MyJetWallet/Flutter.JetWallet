import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/store/iban_add_bank_account_store.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'IbanAddBankAccountRouter')
class IbanAddBankAccountScreen extends StatelessWidget {
  const IbanAddBankAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddBankAccountStore>(
      create: (context) => IbanAddBankAccountStore(),
      builder: (context, child) => const IbanAddBankAccountScreenBody(),
    );
  }
}

class IbanAddBankAccountScreenBody extends StatelessObserverWidget {
  const IbanAddBankAccountScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      loading: IbanAddBankAccountStore.of(context).loader,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.iban_add_bank_account,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: ScrollingFrame(
        children: [
          SFieldDividerFrame(
            child: SStandardField(
              labelText: intl.iban_label,
              maxLength: 30,
              textCapitalization: TextCapitalization.sentences,
              controller: IbanAddBankAccountStore.of(context).labelController,
              onChanged: (text) {
                IbanAddBankAccountStore.of(context).checkButton();
              },
              hideSpace: true,
            ),
          ),
          SFieldDividerFrame(
            child: SStandardField(
              labelText: intl.iban_iban,
              textCapitalization: TextCapitalization.sentences,
              controller: IbanAddBankAccountStore.of(context).ibanController,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                IbanAddBankAccountStore.of(context).checkButton();
              },
              suffixIcons: [
                SIconButton(
                  onTap: () => IbanAddBankAccountStore.of(context).pasteIban(),
                  defaultIcon: const SPasteIcon(),
                  pressedIcon: const SPastePressedIcon(),
                ),
              ],
              maxLines: 3,
              hideSpace: true,
            ),
          ),
          SFieldDividerFrame(
            child: SStandardField(
              readOnly: true,
              enabled: false,
              hideClearButton: true,
              initialValue: '${sUserInfo.firstName} ${sUserInfo.lastName}',
              labelText: intl.iban_benificiary,
              textCapitalization: TextCapitalization.sentences,
              hideSpace: true,
            ),
          ),
          const SpaceH20(),
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SBankIcon(),
                const SpaceW14(),
                Text(
                  intl.iban_terms_1,
                  style: sBodyText2Style,
                ),
              ],
            ),
          ),
          const SpaceH12(),
          SPaddingH24(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SUserIcon(
                  color: colors.black,
                ),
                const SpaceW14(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 88,
                  child: Text(
                    intl.iban_terms_2,
                    style: sBodyText2Style,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          const SpaceH20(),
          const Spacer(),
          SPaddingH24(
            child: Material(
              color: colors.grey5,
              child: SPrimaryButton2(
                active: IbanAddBankAccountStore.of(context).isButtonActive,
                name: intl.iban_add_account,
                onTap: () {
                  IbanAddBankAccountStore.of(context).addAccount();
                },
              ),
            ),
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
