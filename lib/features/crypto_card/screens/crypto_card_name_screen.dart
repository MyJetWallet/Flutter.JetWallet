import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/create_crypto_card_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardNameRoute')
class CryptoCardNameScreen extends StatefulWidget {
  const CryptoCardNameScreen({super.key});

  @override
  State<CryptoCardNameScreen> createState() => _CryptoCardNameScreenState();
}

class _CryptoCardNameScreenState extends State<CryptoCardNameScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = getIt.get<CreateCryptoCardStore>();

    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: '',
          color: colors.gray2,
          header: GlobalBasicAppBar(
            rightIcon: Text(
              intl.crypto_card_name_skip,
              style: STStyles.button.copyWith(
                color: colors.blue,
              ),
            ),
            onLeftIconTap: () {
              sRouter.popUntilRoot();
            },
            onRightIconTap: () {
              store.skipCryptoCardNameSteep();
            },
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
                                  style: STStyles.header5,
                                ),
                              ],
                            ),
                          ),
                          const SpaceH32(),
                          SInput(
                            label: intl.crypto_card_name_card_name,
                            controller: controller,
                            autofocus: true,
                            onChanged: (name) {
                              store.setCryptoCardName(name);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SpaceH32(),
                    const Spacer(),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 16 + MediaQuery.of(context).padding.top <= 24 ? 24 : 16,
                        ),
                        child: SButton.black(
                          text: intl.crypto_card_name_create_card,
                          callback: store.isLableValid
                              ? () {
                                  store.createCryptoCard();
                                }
                              : null,
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
