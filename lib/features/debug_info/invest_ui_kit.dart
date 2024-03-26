import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/invest/ui/dashboard/active_invest_line.dart';
import 'package:jetwallet/features/invest/ui/dashboard/my_portfolio.dart';
import 'package:jetwallet/features/invest/ui/dashboard/new_invest_header.dart';
import 'package:jetwallet/features/invest/ui/invests/invest_line.dart';
import 'package:jetwallet/features/invest/ui/invests/main_switch.dart';
import 'package:jetwallet/features/invest/ui/invests/rollover_line.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_input.dart';
import 'package:jetwallet/features/invest/ui/widgets/slider_thumb_shape.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/signalr_log.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../utils/helpers/currency_from.dart';
import '../invest/ui/dashboard/invest_header.dart';
import '../invest/ui/invests/main_invest_block.dart';

@RoutePage(name: 'InvestUIKITRouter')
class InvestUIKIT extends StatefulWidget {
  const InvestUIKIT({super.key});

  @override
  State<InvestUIKIT> createState() => _InvestUIState();
}

class _InvestUIState extends State<InvestUIKIT> {
  double _currentSliderValue = 200;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final colors = sKit.colors;

    final currency = currencyFrom(currencies, 'USDT');

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Invest UI KIT',
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: SPaddingH24(
            child: Column(
              children: [
                InvestHeader(currency: currency),
                NewInvestHeader(
                  title: intl.invest_new_title,
                  showRollover: false,
                  showModify: false,
                  showIcon: false,
                  showFull: true,
                  onButtonTap: () {},
                ),
                NewInvestHeader(
                  title: intl.invest_new_title,
                  showRollover: true,
                  showModify: false,
                  showIcon: false,
                  showFull: false,
                  onButtonTap: () {},
                ),
                NewInvestHeader(
                  title: intl.invest_new_title,
                  showRollover: false,
                  showModify: true,
                  showIcon: false,
                  showFull: false,
                  onButtonTap: () {},
                ),
                NewInvestHeader(
                  title: intl.invest_new_title,
                  showRollover: false,
                  showModify: false,
                  showIcon: true,
                  showFull: false,
                  onButtonTap: () {},
                ),
                MyPortfolio(
                  pending: Decimal.fromInt(1000),
                  amount: Decimal.fromInt(1100),
                  balance: Decimal.fromInt(12323),
                  percent: Decimal.fromInt(12),
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_my_portfolio,
                  onTap: () {},
                ),
                // SymbolInfo(currency: currency, showProfit: false, price: 1222,),
                // SymbolInfo(currency: currency, showProfit: true, price: 1212, profit: Decimal.fromInt(1000),),
                ActiveInvestLine(profit: Decimal.fromInt(900), amount: Decimal.fromInt(1000)),
                // SymbolInfoLine(currency: currency, price: 1222,),
                // SymbolInfoWithoutChart(currency: currency, price: 1222,),
                MainSwitch(
                  onChangeTab: (value) {},
                  activeTab: 0,
                ),
                MainInvestBlock(
                  pending: Decimal.fromInt(1000),
                  amount: Decimal.fromInt(1100),
                  balance: Decimal.fromInt(12323),
                  percent: Decimal.fromInt(12),
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_active_invest,
                ),
                RolloverLine(mainText: intl.invest_next_rollover, secondaryText: '-0.005% / -07:34:51'),
                InvestLine(
                  currency: currency,
                  price: Decimal.fromInt(1000),
                  operationType: Direction.buy,
                  isPending: false,
                  amount: Decimal.fromInt(900),
                  leverage: Decimal.fromInt(50),
                  isGroup: false,
                  historyCount: 3,
                  profit: Decimal.fromInt(900),
                  profitPercent: Decimal.fromInt(9),
                  accuracy: 2,
                  onTap: () {},
                ),
                const SDivider(),
                InvestLine(
                  currency: currency,
                  price: Decimal.fromInt(1000),
                  operationType: Direction.buy,
                  isPending: false,
                  amount: Decimal.fromInt(900),
                  leverage: Decimal.fromInt(50),
                  isGroup: true,
                  historyCount: 3,
                  profit: Decimal.fromInt(900),
                  profitPercent: Decimal.fromInt(9),
                  accuracy: 2,
                  onTap: () {},
                ),
                const SDivider(),
                InvestLine(
                  currency: currency,
                  price: Decimal.fromInt(1000),
                  operationType: Direction.sell,
                  isPending: true,
                  amount: Decimal.fromInt(900),
                  leverage: Decimal.fromInt(50),
                  isGroup: false,
                  historyCount: 3,
                  profit: Decimal.fromInt(90),
                  profitPercent: Decimal.fromInt(-9),
                  accuracy: 2,
                  onTap: () {},
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.invest_amount,
                      style: STStyles.body2InvestM.copyWith(
                        color: colors.black,
                      ),
                    ),
                    const SpaceH8(),
                    InvestInput(
                      icon: Row(
                        children: [
                          SvgPicture.network(
                            currency.iconUrl,
                            width: 16.0,
                            height: 16.0,
                            placeholderBuilder: (_) {
                              return const SAssetPlaceholderIcon();
                            },
                          ),
                          const SpaceW2(),
                          Text(
                            currency.symbol,
                            style: STStyles.body2InvestM.copyWith(
                              color: colors.black,
                            ),
                          ),
                          const SpaceW10(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpaceH8(),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: colors.black,
                    inactiveTrackColor: colors.grey5,
                    trackShape: const RoundedRectSliderTrackShape(),
                    trackHeight: 6.0,
                    thumbShape: const SliderThumbShape(disabledThumbRadius: 8),
                    thumbColor: colors.black,
                    overlayColor: Colors.transparent,
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                    tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
                    activeTickMarkColor: colors.black,
                    inactiveTickMarkColor: colors.grey4,
                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: colors.blue,
                    valueIndicatorTextStyle: TextStyle(
                      color: colors.brown,
                    ),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    min: 10,
                    max: 10000,
                    divisions: 10,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: intl.invest_amount,
                    onChanged: (String? value) {},
                    hideSpace: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignalRLogDetail extends StatefulWidget {
  const SignalRLogDetail({
    super.key,
    required this.log,
  });

  final SignalrLog log;

  @override
  State<SignalRLogDetail> createState() => _SignalRLogDetailState();
}

class _SignalRLogDetailState extends State<SignalRLogDetail> {
  var filtredLogs = <SLogData>[];

  @override
  void initState() {
    filtredLogs = widget.log.logs!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDateToDMonthYHmFromDate(
              (widget.log.sessionTime ?? DateTime.now()).toString(),
            ),
            style: sSubtitle2Style,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    filtredLogs = widget.log.logs!;
                  });
                },
                child: Text(
                  'Reset',
                  style: sBodyText1Style.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    filtredLogs = widget.log.logs!
                        .where(
                          (element) => element.type != SLogType.ping && element.type != SLogType.pong,
                        )
                        .toList();
                  });
                },
                child: Text(
                  'Hide Ping/Pong messages',
                  style: sBodyText1Style.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            itemCount: filtredLogs.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Action: ${filtredLogs[index].type}',
                    style: sBodyText1Style.copyWith(
                      color: filtredLogs[index].type == SLogType.error ? sKit.colors.red : sKit.colors.black,
                    ),
                  ),
                  Text(
                    'Time: ${formatDateToHms(
                      (filtredLogs[index].date ?? DateTime.now()).toString(),
                    )}',
                    style: sBodyText2Style.copyWith(
                      color: sKit.colors.grey1,
                    ),
                  ),
                  if (filtredLogs[index].type == SLogType.error) ...[
                    Text(
                      filtredLogs[index].error ?? '',
                      style: sBodyText2Style,
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
