import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/active_earn_widget.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit_updated/widgets/button/main/simple_button.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnPositionActiveRouter')
class EarnPositionActiveScreen extends StatelessWidget {
  const EarnPositionActiveScreen({required this.earnPosition, super.key});

  final EarnPositionClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final currencies = sSignalRModules.currenciesList;
        final colors = sKit.colors;
        final currency = currencies.firstWhere(
          (currency) => currency.symbol == earnPosition.assetId,
          orElse: () => CurrencyModel.empty(),
        );

        final store = Provider.of<EarnStore>(context);

        return Scaffold(
          backgroundColor: colors.white,
          body: Column(
            children: [
              GlobalBasicAppBar(
                hasRightIcon: false,
                title: currency.description,
                subtitle: earnPosition.offers.firstOrNull?.name,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: ActiveEarnWidget(earnPosition: earnPosition),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 24,
                  left: 24,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: earnPosition.status == EarnPositionStatus.active
                    ? Column(
                        children: [
                          SButton.blue(
                            text: intl.earn_top_up,
                            callback: () {
                              sRouter.push(
                                EarnTopUpAmountRouter(
                                  earnPosition: earnPosition,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          SButton.text(
                            text: intl.earn_withdraw,
                            callback: () {
                              store.startEartWithdrawFlow(
                                earnPosition: earnPosition,
                              );
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
