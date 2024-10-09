import 'dart:async';
import 'dart:developer' as dev;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/ui/invests/data_line.dart';
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
import '../dashboard/new_invest_header.dart';
import '../invests/invest_line.dart';
import '../invests/journal_item.dart';
import '../invests/rollover_line.dart';
import 'invest_rollover_bottom_sheet.dart';

void showInvestReportBottomSheet(
  BuildContext context,
  InvestPositionModel position,
  InvestInstrumentModel instrument,
) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinnedBottom: (position.status != PositionStatus.cancelled && position.status != PositionStatus.closed)
        ? Material(
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
          )
        : null,
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
    investNewStore.getAsset('USDT');
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
    final investNewStore = getIt.get<InvestNewStore>();
    final currencies = sSignalRModules.currenciesList;
    final colors = sKit.colors;
    final currency = currencyFrom(currencies, widget.instrument.name ?? '');
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    dev.log('positon ${widget.position}');
    dev.log('instrument ${widget.position}');

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {
          return Column(
            children: [
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
                currency: currency,
                isClosedPosition: widget.position.status == PositionStatus.closed,
                price: widget.position.status == PositionStatus.closed
                    ? widget.position.profitLoss!
                    : investStore.getProfitByPosition(widget.position),
                operationType: widget.position.direction ?? Direction.undefined,
                isPending: widget.position.status == PositionStatus.cancelled,
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
              const SpaceH8(),
              DataLine(
                mainText: intl.invest_report_ticket,
                secondaryText: widget.position.id ?? '',
              ),
              const SpaceH8(),
              const SDivider(),
              const SpaceH8(),
              if (widget.position.status != PositionStatus.cancelled) ...[
                DataLine(
                  mainText: intl.invest_open_price,
                  secondaryText: (widget.position.openPrice ?? Decimal.zero).toFormatSum(
                    accuracy: widget.instrument.priceAccuracy ?? 2,
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_open_data,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.openTimestamp.toString(),
                    'dd.MM.yyyy',
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_open_time,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.openTimestamp.toString(),
                    'HH:mm:ss',
                  ),
                ),
              ] else ...[
                DataLine(
                  mainText: intl.invest_report_order_price,
                  secondaryText: (widget.position.pendingPrice ?? Decimal.zero).toFormatSum(
                    accuracy: widget.instrument.priceAccuracy ?? 2,
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_order_date,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.creationTimestamp.toString(),
                    'dd.MM.yyyy',
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_order_time,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.creationTimestamp.toString(),
                    'hh:mm:ss',
                  ),
                ),
              ],
              const SpaceH8(),
              const SDivider(),
              const SpaceH8(),
              DataLine(
                mainText: '${intl.invest_report_amount} ${widget.position.amountAssetId}',
                secondaryText: (widget.position.amount ?? Decimal.zero).toFormatSum(accuracy: 2),
              ),
              const SpaceH8(),
              DataLine(
                mainText: intl.invest_report_multiplicator,
                secondaryText: 'x${widget.position.multiplicator} ',
              ),
              const SpaceH8(),
              DataLine(
                mainText: '${intl.invest_report_volume} ${widget.position.amountAssetId}',
                secondaryText: (widget.position.volume ?? Decimal.zero).toFormatSum(accuracy: 2),
              ),
              if (widget.position.status != PositionStatus.cancelled) ...[
                const SpaceH8(),
                DataLine(
                  mainText: '${intl.invest_report_volume} ${widget.instrument.name}',
                  secondaryText: (widget.position.volumeBase ?? Decimal.zero).toFormatSum(accuracy: currency.accuracy),
                ),
                const SpaceH8(),
              ],
              if (widget.position.stopLossType != TPSLType.undefined ||
                  widget.position.takeProfitType != TPSLType.undefined) ...[
                if (widget.position.takeProfitType != TPSLType.undefined) ...[
                  const SDivider(),
                  const SpaceH8(),
                  DataLine(
                    withDot: true,
                    dotColor: colors.green,
                    mainText: intl.invest_limits_take_profit,
                    secondaryText: widget.position.takeProfitType == TPSLType.amount
                        ? (widget.position.takeProfitAmount ?? Decimal.zero).toFormatCount(
                            accuracy: 2,
                            symbol: 'USDT',
                          )
                        : (widget.position.takeProfitPrice ?? Decimal.zero).toFormatCount(
                            accuracy: widget.instrument.priceAccuracy ?? 2,
                          ),
                  ),
                  if (widget.position.stopLossType == TPSLType.undefined) const SpaceH8(),
                ],
              ],
              if (widget.position.stopLossType != TPSLType.undefined) ...[
                if (widget.position.takeProfitType == TPSLType.undefined) const SDivider(),
                const SpaceH8(),
                DataLine(
                  withDot: true,
                  dotColor: colors.red,
                  mainText: intl.invest_limits_stop_loss,
                  secondaryText: widget.position.stopLossType == TPSLType.amount
                      ? ((widget.position.stopLossAmount ?? Decimal.zero) * Decimal.fromInt(-1)).toFormatCount(
                          accuracy: 2,
                          symbol: 'USDT',
                        )
                      : ((widget.position.stopLossPrice ?? Decimal.zero) * Decimal.fromInt(-1)).toFormatCount(
                          accuracy: widget.instrument.priceAccuracy ?? 2,
                        ),
                ),
                const SpaceH8(),
              ],
              const SDivider(),
              const SpaceH8(),
              DataLine(
                mainText: intl.invest_report_market_pl,
                secondaryText: isBalanceHide
                    ? '**** USDT'
                    : investStore.getMarketPLByPosition(widget.position).toFormatSum(
                          accuracy: investNewStore.assetUSDT?.accuracy ?? 2,
                          symbol: 'USDT',
                        ),
              ),
              const SpaceH8(),
              DataLine(
                mainText: intl.invest_report_open_fee,
                secondaryText: isBalanceHide
                    ? '**** USDT'
                    : ((widget.position.openFee ?? Decimal.zero) * Decimal.parse('-1')).toFormatSum(
                        accuracy: investNewStore.assetUSDT?.accuracy ?? 2,
                        symbol: 'USDT',
                      ),
              ),
              const SpaceH8(),
              if (widget.position.status == PositionStatus.closed) ...[
                DataLine(
                  mainText: intl.invest_report_close_fee,
                  secondaryText: isBalanceHide
                      ? '**** USDT'
                      : ((widget.position.closeFee ?? Decimal.zero) * Decimal.parse('-1')).toFormatSum(
                          accuracy: investNewStore.assetUSDT?.accuracy ?? 2,
                          symbol: 'USDT',
                        ),
                ),
                const SpaceH8(),
              ],
              DataLine(
                mainText: intl.invest_report_rollover,
                secondaryText: isBalanceHide
                    ? '**** USDT'
                    : (widget.position.rollOver ?? Decimal.zero).toFormatSum(
                        accuracy: investNewStore.assetUSDT?.accuracy ?? 2,
                        symbol: 'USDT',
                      ),
              ),
              const SpaceH8(),
              if (widget.position.status != PositionStatus.cancelled) ...[
                const SpaceH8(),
                if (widget.position.status == PositionStatus.closed) ...[
                  const SDivider(),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_report_close_price,
                    secondaryText: (widget.position.closePrice ?? Decimal.zero).toFormatSum(
                      accuracy: widget.instrument.priceAccuracy ?? 2,
                    ),
                  ),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_report_close_date,
                    secondaryText: normalizeAndFormatDateTime(
                      widget.position.closeTimestamp.toString(),
                      'dd.MM.yyyy',
                    ),
                  ),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_report_close_time,
                    secondaryText: normalizeAndFormatDateTime(
                      widget.position.closeTimestamp.toString(),
                      'HH:mm:ss',
                    ),
                  ),
                  const SpaceH8(),
                ],
                if (widget.position.status != PositionStatus.cancelled &&
                    widget.position.status != PositionStatus.closed) ...[
                  const SDivider(),
                  const SpaceH8(),
                  DataLine(
                    mainText: intl.invest_liquidation_price,
                    secondaryText: (widget.position.stopOutPrice ?? Decimal.zero).toFormatSum(
                      accuracy: widget.instrument.priceAccuracy ?? 2,
                    ),
                  ),
                  const SpaceH8(),
                ],
              ] else ...[
                const SpaceH8(),
                const SDivider(),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_delete_date,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.closeTimestamp.toString(),
                    'dd.MM.yyyy',
                  ),
                ),
                const SpaceH8(),
                DataLine(
                  mainText: intl.invest_report_delete_time,
                  secondaryText: normalizeAndFormatDateTime(
                    widget.position.closeTimestamp.toString(),
                    'hh:mm:ss',
                  ),
                ),
                const SpaceH8(),
              ],
              if (investPositionStore.rolloverList.isNotEmpty)
                NewInvestHeader(
                  showRollover: true,
                  showModify: false,
                  showIcon: false,
                  showFull: false,
                  onButtonTap: () {
                    showInvestRolloverBottomSheet(
                      context,
                      widget.position,
                      widget.instrument,
                    );
                  },
                  title: intl.invest_report_journal,
                ),
              for (final item in investPositionStore.journalList) ...[
                if (item.auditEvent != PositionAuditEvent.undefined &&
                    item.auditEvent != PositionAuditEvent.createMarketOpening &&
                    item.auditEvent != PositionAuditEvent.openedToClosing &&
                    item.auditEvent != PositionAuditEvent.rollOverReCalc)
                  JournalItem(
                    item: item,
                    instrument: widget.instrument,
                    position: widget.position,
                  ),
              ],
              const SpaceH34(),
            ],
          );
        },
      ),
    );
  }

  String normalizeAndFormatDateTime(String timestamp, String dateFormat) {
    var normalizedTimestamp = timestamp;

    if (!normalizedTimestamp.endsWith('Z') && !RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(normalizedTimestamp)) {
      normalizedTimestamp = '${normalizedTimestamp}Z';
    }

    final dateTimeUtc = DateTime.parse(normalizedTimestamp).toUtc();
    final dateTimeLocal = dateTimeUtc.toLocal();

    return DateFormat(dateFormat).format(dateTimeLocal);
  }
}
