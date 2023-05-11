import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_detail_store.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SendCardDetailRouter')
class SendCardDetailScreen extends StatelessWidget {
  const SendCardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<SendCardDetailStore>(
      create: (context) => SendCardDetailStore(),
      builder: (context, child) => const SendCardDetailScreenBody(),
    );
  }
}

class SendCardDetailScreenBody extends StatefulObserverWidget {
  const SendCardDetailScreenBody({super.key});

  @override
  State<SendCardDetailScreenBody> createState() =>
      _SendCardDetailScreenBodyState();
}

class _SendCardDetailScreenBodyState extends State<SendCardDetailScreenBody> {
  TextEditingController cardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = SendCardDetailStore.of(context);

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.global_send_title,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SFieldDividerFrame(
                  child: SStandardField(
                    controller: cardNumberController,
                    labelText: intl.addCircleCard_cardNumber,
                    keyboardType: TextInputType.number,
                    isError: store.cardNumberError,
                    disableErrorOnChanged: false,
                    hideSpace: true,
                    onErase: () {
                      store.updateCardNumber('');
                    },
                    suffixIcons: [
                      SIconButton(
                        onTap: () {
                          print('paste');

                          store.pasteCardNumber(cardNumberController);
                        },
                        defaultIcon: const SPasteIcon(),
                        pressedIcon: const SPastePressedIcon(),
                      ),
                    ],
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
                        separator: '\u{2005}',
                      ),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\u2005]'),
                      ),
                    ],
                    onChanged: (str) {
                      store.updateCardNumber(str);
                      setState(() {});
                    },
                  ),
                ),
                SPaddingH24(
                  child: SPolicyCheckbox(
                    height: 130,
                    firstText: intl.send_globally_cond_text_1,
                    userAgreementText: ' ${intl.send_globally_cond_text_2}',
                    betweenText: ', ',
                    privacyPolicyText: intl.send_globally_cond_text_3,
                    secondText: ' ${intl.send_globally_cond_text_4} \n',
                    activeText: intl.send_globally_cond_text_5,
                    isChecked: getIt<AppStore>().isAcceptedGlobalSendTC,
                    onCheckboxTap: () {
                      getIt<AppStore>().setIsAcceptedGlobalSendTC(
                        !getIt<AppStore>().isAcceptedGlobalSendTC,
                      );
                    },
                    onUserAgreementTap: () {
                      launchURL(context,
                          'https://simple.app/terms-and-conditions/sendglobally/');
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(context,
                          'https://globalltd.xyz/terms-and-conditions');
                    },
                    onActiveTextTap: () {
                      launchURL(
                          context, 'https://globalltd.xyz/privacy-policy');
                    },
                  ),
                ),
                const Spacer(),
                SPaddingH24(
                  child: Material(
                    color: colors.grey5,
                    child: SPrimaryButton2(
                      active: store.isCardNumberValid &&
                          getIt<AppStore>().isAcceptedGlobalSendTC,
                      name: intl.addCircleCard_continue,
                      onTap: () {
                        sRouter.push(
                          SendGloballyAmountRouter(
                            cardNumber: store.cardNumber,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
