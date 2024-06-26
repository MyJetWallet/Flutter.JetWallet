import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/round/round_button.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class SimpleCoinAssetItem extends StatelessWidget {
  const SimpleCoinAssetItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final isSimpleCoinAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
        .any((element) => element.id == AssetPaymentProductsEnum.simpleTapToken);

    if (!isSimpleCoinAvaible) return const Offstage();

    return Observer(
      builder: (context) {
        final balance = sSignalRModules.smplWalletModel.profile.balance;
        final formatedBalance = volumeFormat(
          decimal: balance,
          symbol: 'SMPL',
        );

        return balance != Decimal.zero
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 7,
                ),
                child: SafeGesture(
                  onTap: () async {
                    sAnalytics.tapOnTheButtonSimplecoinOnWalletScreen();
                    await sRouter.push(const MySimpleCoinsRouter());
                  },
                  child: Container(
                    height: 67,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      image: const DecorationImage(
                        image: AssetImage(simpleCoinAssetBackground),
                        fit: BoxFit.contain,
                        alignment: Alignment(0.2, 0),
                      ),
                      color: colors.extraLightsPurple,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: Assets.svg.assets.crypto.smpl.simpleSvg(
                            width: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          intl.simplecoin_simplecoin,
                          style: STStyles.subtitle1,
                        ),
                        const Spacer(),
                        RoundButton(
                          value: getIt<AppStore>().isBalanceHide ? '**** SMPL' : formatedBalance,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Offstage();
      },
    );
  }
}
