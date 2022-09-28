import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';
import 'components/earn_body_header.dart';

class EarnPinned extends StatelessObserverWidget {
  const EarnPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final colors = sKit.colors;
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    earnGroupImageAsset,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 24.0,
              right: 24.0,
              child: SIconButton(
                onTap: () => Navigator.pop(context),
                defaultIcon: const SEraseMarketIcon(),
                pressedIcon: const SErasePressedIcon(),
              ),
            ),
            Positioned(
              width: mediaQuery.size.width,
              top: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.0,
                    height: 4.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SpaceH33(),
        SPaddingH24(
          child: EarnBodyHeader(
            currencies: currencies,
            colors: colors,
          ),
        ),
      ],
    );
  }
}
