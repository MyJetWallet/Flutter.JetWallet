import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/ui/invests/data_line.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currency_from.dart';
import '../../stores/dashboard/invest_new_store.dart';
import '../../stores/dashboard/invest_positions_store.dart';
import '../dashboard/invest_header.dart';
import '../dashboard/new_invest_header.dart';
import '../invests/invest_line.dart';
import '../invests/rollover_line.dart';

void showInvestRolloverBottomSheet(
  BuildContext context,
  InvestPositionModel position,
  InvestInstrumentModel instrument,
) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinnedBottom: Material(
      color: SColorsLight().white,
      child: Observer(
        builder: (BuildContext context) {
          return SizedBox(
            height: 98.0,
            child: Column(
              children: [
                const SpaceH20(),
                SPaddingH24(
                  child: Row(
                    children: [
                      Expanded(
                        child: SIButton(
                          activeColor: SColorsLight().grey5,
                          activeNameColor: SColorsLight().black,
                          inactiveColor: SColorsLight().grey2,
                          inactiveNameColor: SColorsLight().grey4,
                          active: true,
                          name: intl.invest_alert_got_it,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SpaceH34(),
              ],
            ),
          );
        },
      ),
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [
      InvestList(
        position: position,
        instrument: instrument,
      ),
    ],
  );
}

class InvestList extends StatefulObserverWidget {
  const InvestList({
    required this.position,
    required this.instrument,
  });
  final InvestPositionModel position;
  final InvestInstrumentModel instrument;

  @override
  State<InvestList> createState() => _InvestListScreenState();
}

class _InvestListScreenState extends State<InvestList> {
  late Timer updateTimer;
  late String timerUpdated;

  @override
  void initState() {
    super.initState();
    final investNewStore = getIt.get<InvestNewStore>();
    investNewStore.setPosition(widget.position);
    final a = DateTime.parse('${widget.instrument.nextRollOverTime}');
    final b = DateTime.now();
    final difference = a.difference(b);
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    timerUpdated = '-$hours:'
        '${minutes < 10 ? '0' : ''}$minutes:'
        '${seconds < 10 ? '0' : ''}$seconds';

    updateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final a = DateTime.parse('${widget.instrument.nextRollOverTime}');
        final b = DateTime.now();
        final difference = a.difference(b);
        final hours = difference.inHours % 24;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;
        setState(() {
          timerUpdated = '-$hours:'
              '${minutes < 10 ? '0' : ''}$minutes:'
              '${seconds < 10 ? '0' : ''}$seconds';
        });
      },
    );
  }

  @override
  void dispose() {
    updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final investStore = getIt.get<InvestDashboardStore>();
    final investPositionStore = getIt.get<InvestPositionsStore>();
    final currencies = sSignalRModules.currenciesList;
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {
          return Column(
            children: [
              InvestHeader(
                currency: currencyFrom(currencies, widget.instrument.name ?? ''),
                hideWallet: true,
                withBackBlock: true,
                withBigPadding: false,
                withDivider: false,
                onBackButton: () {
                  Navigator.pop(context);
                },
              ),
              if (widget.position.status != PositionStatus.cancelled && widget.position.status != PositionStatus.closed)
                Observer(
                  builder: (BuildContext context) {
                    final rolloverPercent = ((widget.position.direction == Direction.buy
                                ? widget.instrument.rollBuy!
                                : widget.instrument.rollSell!) *
                            Decimal.fromInt(100))
                        .toDouble()
                        .toFormatPercentPriceChange();

                    return RolloverLine(
                      mainText: intl.invest_next_rollover,
                      secondaryText: '$rolloverPercent / $timerUpdated',
                    );
                  },
                ),
              InvestLine(
                currency: currencyFrom(currencies, widget.instrument.name ?? ''),
                price: investStore.getProfitByPosition(widget.position),
                operationType: widget.position.direction ?? Direction.undefined,
                isPending: false,
                amount: widget.position.amount ?? Decimal.zero,
                leverage: Decimal.fromInt(widget.position.multiplicator ?? 0),
                isGroup: false,
                historyCount: 1,
                profit: investStore.getProfitByPosition(widget.position),
                profitPercent: investStore.getYieldByPosition(widget.position),
                accuracy: widget.instrument.priceAccuracy ?? 2,
                onTap: () {},
              ),
              const SDivider(),
              NewInvestHeader(
                showRollover: false,
                showModify: false,
                showIcon: false,
                showFull: false,
                title: intl.invest_rollover_report,
              ),
              for (final item in investPositionStore.rolloverList) ...[
                RolloverLine(
                  mainText: DateFormat('dd.MM.yyyy / hh:mm:ss').format(item.timestamp),
                  secondaryText: '',
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_rollover,
                  secondaryText: isBalanceHide
                      ? '**** USDT'
                      : item.rollOverAmount.toFormatSum(
                          accuracy: 2,
                          symbol: 'USDT',
                        ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_rollover_rate,
                  secondaryText: '${item.rollOver > Decimal.zero ? '+' : '-'}${item.rollOver.abs()}%',
                ),
                const SpaceH20(),
              ],
            ],
          );
        },
      ),
    );
  }
}
