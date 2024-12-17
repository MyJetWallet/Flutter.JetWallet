import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';

@RoutePage(name: 'JarShareRouter')
class JarShareScreen extends StatefulWidget {
  const JarShareScreen({
    super.key,
  });

  @override
  State<JarShareScreen> createState() => _JarShareScreenState();
}

class _JarShareScreenState extends State<JarShareScreen> {
  String selectedLanguage = 'GB';

  @override
  void initState() {
    super.initState();

    sAnalytics.jarScreenViewShareJar();

    if (getIt.get<AppStore>().locale!.languageCode == 'uk') {
      setState(() {
        selectedLanguage = 'UA';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<JarsStore>();
    final selectedJar = store.selectedJar!;

    var remainedAmount = selectedJar.target - selectedJar.balanceInJarAsset;
    if (remainedAmount < 0) {
      remainedAmount = 0;
    }

    final colors = SColorsLight();

    final networks = getIt
        .get<FormatService>()
        .findCurrency(
          assetSymbol: selectedJar.assetSymbol,
        )
        .networksForBlockchainSend;

    return SPageFrame(
      loaderText: '',
      color: colors.white,
      header: GlobalBasicAppBar(
        title: intl.jar_share_jar,
        subtitle: selectedJar.title,
        hasRightIcon: false,
        onLeftIconTap: () {
          getIt<AppRouter>().popUntil((route) {
            return route.settings.name == JarRouter.name;
          });
        },
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    QrImageView(
                      data: selectedJar.addresses.first.address,
                      size: 200.0,
                      padding: EdgeInsets.zero,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      embeddedImage: AssetImage(
                        Assets.svg.assets.crypto.tether.path,
                        package: 'simple_kit_updated',
                      ),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(32, 32),
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    _buildShareItem(
                      intl.jar_language,
                      '',
                      true,
                      false,
                    ),
                    _buildShareItem(
                      intl.jar_remained_amount,
                      Decimal.parse((remainedAmount).toString()).toFormatCount(
                        accuracy:
                            getIt.get<FormatService>().findCurrency(assetSymbol: selectedJar.assetSymbol).accuracy,
                        symbol: selectedJar.addresses.first.assetSymbol,
                      ),
                      false,
                      false,
                    ),
                    _buildShareItem(
                      intl.jar_address,
                      selectedJar.addresses.first.address,
                      false,
                      true,
                      true,
                    ),
                    _buildShareItem(
                      intl.jar_network,
                      networks.firstWhere((value) => value.id == selectedJar.addresses.first.blockchain).description,
                      false,
                      false,
                    ),
                    const SizedBox(
                      height: 50.0 + 56.0,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: SButton.black(
                    text: intl.jar_share,
                    callback: () async {
                      sAnalytics.jarTapOnButtonShareJarOnShareJar(
                        language: selectedLanguage == 'GB' ? 'English' : 'Ukrainian',
                      );

                      final result = await getIt
                          .get<JarsStore>()
                          .shareJar(jarId: selectedJar.id, lang: selectedLanguage == 'GB' ? 'en' : 'uk');

                      String shareText;
                      if (selectedLanguage == 'GB') {
                        shareText = '${selectedJar.title}\n\n🔗 Link to the jar:\n${result ?? ''}';
                      } else {
                        shareText = '${selectedJar.title}\n\n🔗 Посилання на банку:\n${result ?? ''}';
                      }
                      await Share.share(shareText, subject: selectedJar.title);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareItem(String title, String text, bool isCountry, bool withCopy, [bool isAddress = false]) {
    final colors = SColorsLight();

    return SafeGesture(
      onTap: () {
        if (isCountry) {
          showBasicBottomSheet(
            context: context,
            color: colors.white,
            header: BasicBottomSheetHeaderWidget(
              title: intl.jar_language,
            ),
            children: [
              SafeGesture(
                onTap: () {
                  setState(() {
                    selectedLanguage = 'GB';
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 18.0,
                  ),
                  child: Row(
                    children: [
                      const FlagItem(
                        countryCode: 'GB',
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        'English',
                        style: STStyles.subtitle1.copyWith(
                          color: SColorsLight().black,
                        ),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) => AnimatedCrossFade(
                          firstChild: Assets.svg.medium.checkmark.simpleSvg(),
                          secondChild: Container(),
                          crossFadeState:
                              selectedLanguage == 'GB' ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeGesture(
                onTap: () {
                  setState(() {
                    selectedLanguage = 'UA';
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 18.0,
                  ),
                  child: Row(
                    children: [
                      const FlagItem(
                        countryCode: 'UA',
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        'Ukrainian',
                        style: STStyles.subtitle1.copyWith(
                          color: SColorsLight().black,
                        ),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) => AnimatedCrossFade(
                          firstChild: Assets.svg.medium.checkmark.simpleSvg(),
                          secondChild: Container(),
                          crossFadeState:
                              selectedLanguage == 'UA' ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 58.0),
            ],
          );
        }
      },
      child: Container(
        height: isAddress ? 100.0 : 82.0,
        padding: const EdgeInsets.only(
          top: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isCountry
                        ? STStyles.captionMedium.copyWith(
                            color: SColorsLight().gray8,
                          )
                        : STStyles.body2Medium.copyWith(
                            color: SColorsLight().gray10,
                          ),
                  ),
                  if (isCountry)
                    Row(
                      children: [
                        FlagItem(
                          countryCode: selectedLanguage,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          selectedLanguage == 'GB' ? 'English' : 'Ukrainian',
                          style: STStyles.subtitle1.copyWith(
                            color: SColorsLight().black,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      text,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: isAddress
                          ? STStyles.subtitle2.copyWith(
                              color: SColorsLight().black,
                            )
                          : STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 24.0,
            ),
            if (withCopy)
              Center(
                child: SafeGesture(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: text,
                      ),
                    );

                    sNotification.showError(
                      intl.copy_message,
                      id: 1,
                      isError: false,
                    );
                  },
                  child: Assets.svg.medium.copy.simpleSvg(
                    height: 24.0,
                    width: 24.0,
                    color: SColorsLight().gray8,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
