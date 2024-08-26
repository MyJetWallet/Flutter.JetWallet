import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'JarShareRouter')
class JarShareScreen extends StatefulWidget {
  const JarShareScreen({
    required this.jar,
    super.key,
  });

  final JarResponseModel jar;

  @override
  State<JarShareScreen> createState() => _JarShareScreenState();
}

class _JarShareScreenState extends State<JarShareScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    return sk.SPageFrame(
      loaderText: '',
      color: colors.white,
      header: GlobalBasicAppBar(
        title: intl.jar_share_jar,
        subtitle: widget.jar.title,
        hasRightIcon: false,
        onLeftIconTap: () {
          getIt<AppRouter>().popUntil((route) {
            return route.settings.name == JarRouter.name;
          });
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(),
            QrImageView(
              data: widget.jar.addresses.first.address,
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
            const Spacer(),
            _buildShareItem(
              intl.jar_language,
              '',
              true,
              false,
            ),
            _buildShareItem(
              intl.jar_remained_amount,
              Decimal.parse(widget.jar.target.toString()).toFormatCount(
                accuracy: 0,
                symbol: widget.jar.addresses.first.assetSymbol,
              ),
              false,
              false,
            ),
            _buildShareItem(
              intl.jar_address,
              widget.jar.addresses.first.address,
              false,
              true,
              true,
            ),
            _buildShareItem(
              intl.jar_network,
              'TRC20',
              false,
              true,
            ),
            SButton.black(
              text: intl.jar_share,
              callback: () async {
                final result = await getIt.get<JarsStore>().shareJar(jarId: widget.jar.id, lang: 'ua');

                await Share.share(result ?? '');
              },
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(String title, String text, bool isCountry, bool withCopy, [bool isAddress = false]) {
    return Container(
      height: 82.0,
      padding: const EdgeInsets.only(
        top: 18.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: STStyles.captionMedium.copyWith(
                    color: SColorsLight().gray8,
                  ),
                ),
                if (isCountry)
                  Row(
                    children: [
                      SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: Image.asset('assets/images/flag.png'),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Ukraine',
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
            SafeGesture(
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
                height: 20.0,
                width: 20.0,
                color: SColorsLight().gray8,
              ),
            ),
        ],
      ),
    );
  }
}
