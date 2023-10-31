import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showBankTransforSelect(BuildContext context, SimpleBankingAccount bankingAccount) {
  if (getIt.get<IbanStore>().contacts.isEmpty) {
    sRouter.push(IbanAddBankAccountRouter()).then((value) async {
      await getIt.get<IbanStore>().getAddressBook();

      await getIt<AppRouter>()
          .push(
            IbanSendAmountRouter(
              contact: getIt.get<IbanStore>().contacts[0],
              bankingAccount: bankingAccount,
            ),
          )
          .then(
            (value) => getIt.get<IbanStore>().getAddressBook(),
          );
    });

    return;
  }

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.bankAccountsSelectPopupTitle,
    ),
    children: [
      const SpaceH12(),
      ShowBankTransferSelect(
        bankingAccount: bankingAccount,
      ),
      const SpaceH42(),
    ],
  );
}

class ShowBankTransferSelect extends StatelessObserverWidget {
  const ShowBankTransferSelect({
    super.key,
    required this.bankingAccount,
  });

  final SimpleBankingAccount bankingAccount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = getIt.get<IbanStore>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: colors.yellowLight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SUserIcon(
                      color: colors.black,
                    ),
                  ),
                  const SpaceW14(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 88,
                    child: Text(
                      intl.bankAccountsSelectPopup,
                      style: sBodyText2Style,
                      maxLines: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SpaceH16(),
        SPaddingH24(
          child: Text(
            intl.bankAccountsSelectPopupMyAccounts,
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: store.contacts.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SCardRow(
              icon: const SizedBox(
                width: 24,
                height: 24,
                child: SAccountIcon(),
              ),
              rightIcon: Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: SIconButton(
                  onTap: () {
                    sRouter.push(
                      IbanEditBankAccountRouter(
                        contact: store.contacts[index],
                      ),
                    );
                  },
                  defaultIcon: const SEditIcon(),
                  pressedIcon: const SEditIcon(
                    color: Color(0xFFA8B0BA),
                  ),
                ),
              ),
              name: store.contacts[index].name ?? '',
              amount: '',
              helper: store.contacts[index].iban ?? '',
              description: '',
              needSpacer: true,
              onTap: () {
                getIt<AppRouter>()
                    .push(
                      IbanSendAmountRouter(
                        contact: store.contacts[index],
                        bankingAccount: bankingAccount,
                      ),
                    )
                    .then(
                      (value) => store.getAddressBook(),
                    );
              },
            );
          },
        ),
        SCardRow(
          icon: SizedBox(
            width: 24,
            height: 24,
            child: SPlusIcon(
              color: colors.blue,
            ),
          ),
          //rightIcon: const SEditIcon(),
          name: intl.iban_add_bank_account,
          amount: '',
          helper: intl.iban_local_euro_accounts_only,
          description: '',
          onTap: () {
            sAnalytics.tapOnTheButtonAddBankAccount();

            sRouter.push(IbanAddBankAccountRouter()).then((value) async {
              await getIt.get<IbanStore>().getAddressBook();

              await getIt<AppRouter>()
                  .push(
                    IbanSendAmountRouter(
                      contact: getIt.get<IbanStore>().contacts[0],
                      bankingAccount: bankingAccount,
                    ),
                  )
                  .then(
                    (value) => getIt.get<IbanStore>().getAddressBook(),
                  );
            });
          },
        ),
      ],
    );
  }
}
