import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/add_circle_card/helper/masked_text_input_formatter.dart';
import 'package:jetwallet/features/add_circle_card/ui/widgets/scrolling_frame.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_detail_store.dart';
import 'package:jetwallet/features/withdrawal/ui/withdrawal_ammount.dart';
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

class SendCardDetailScreenBody extends StatelessObserverWidget {
  const SendCardDetailScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = SendCardDetailStore.of(context);

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: "Receiver's card details",
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
                    labelText: intl.addCircleCard_cardNumber,
                    keyboardType: TextInputType.number,
                    isError: store.cardNumberError,
                    disableErrorOnChanged: false,
                    controller: store.cardNumberController,
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
                        separator: '\u{2005}',
                      ),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\u2005]'),
                      ),
                    ],
                    onChanged: store.updateCardNumber,
                  ),
                ),
                const Spacer(),
                SPaddingH24(
                  child: Material(
                    color: colors.grey5,
                    child: SPrimaryButton2(
                      active: store.isCardNumberValid,
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
