import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/prepaid_card/widgets/prepaid_card_profile_banner.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class AccountScreenBanner extends StatelessWidget {
  const AccountScreenBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final isPrepaidCardAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[]).any(
          (element) => element.id == AssetPaymentProductsEnum.prepaidCard,
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: isPrepaidCardAvaible ? 16 : 0,
          ),
          child: Builder(
            builder: (context) {
              if (isPrepaidCardAvaible) {
                return const PrepaidCardProfileBanner();
              } else {
                return const Offstage();
              }
            },
          ),
        );
      },
    );
  }
}
