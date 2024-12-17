import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:flutter_ui_kit/widgets/shared/simple_safe_button_padding.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_name_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'CryptoCardNameRoute')
class CryptoCardNameScreen extends StatelessWidget {
  const CryptoCardNameScreen({
    super.key,
    required this.cardId,
    this.initialLabel,
    this.isCreateFlow = true,
  });

  final String cardId;
  final String? initialLabel;
  final bool isCreateFlow;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardNameStore(
        cardId: cardId,
        initialLabel: initialLabel,
      ),
      child: _CardNameBody(isCreateFlow: isCreateFlow),
    );
  }
}

class _CardNameBody extends StatelessWidget {
  const _CardNameBody({
    this.isCreateFlow = true,
  });

  final bool isCreateFlow;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = CryptoCardNameStore.of(context);

    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: intl.loader_please_wait,
          loading: store.loader,
          color: colors.gray2,
          header: GlobalBasicAppBar(
            hasRightIcon: isCreateFlow,
            rightIcon: Text(
              intl.crypto_card_name_skip,
              style: STStyles.button.copyWith(
                color: colors.blue,
              ),
            ),
            onRightIconTap: () {
              sRouter.popUntilRoot();
            },
            hasLeftIcon: !isCreateFlow,
          ),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    ColoredBox(
                      color: colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 172,
                            child: Image.asset(
                              cryptoCardPreviewSmall,
                            ),
                          ),
                          SPaddingH24(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  intl.crypto_card_name_your_card,
                                  style: STStyles.header6,
                                ),
                              ],
                            ),
                          ),
                          const SpaceH16(),
                          SInput(
                            label: intl.crypto_card_name_card_name,
                            controller: store.controller,
                            autofocus: true,
                            onChanged: (name) {
                              store.setCryptoCardName(name);
                            },
                            maxLength: store.nameMaxLength,
                          ),
                        ],
                      ),
                    ),
                    const SpaceH26(),
                    const Spacer(),
                    SafeArea(
                      top: false,
                      child: SSafeButtonPadding(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 8, // отступ кнопки (8)
                          ),
                          child: SButton.black(
                            text: isCreateFlow ? intl.crypto_card_continue : intl.crypto_card_lable_save,
                            callback: store.isNameValid ? store.changeCardName : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
