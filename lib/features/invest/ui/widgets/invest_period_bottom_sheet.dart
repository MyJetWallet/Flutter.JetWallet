import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/ui/invests/bit_of_tab.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/button/invest_buttons/invest_button.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../utils/enum.dart';

void showInvestPeriodBottomSheet(
    BuildContext context,
    Function(InvestHistoryPeriod value) onConfirm,
    InvestHistoryPeriod activePeriod,
) {

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: SPaddingH24(
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width - 48,
        child: Column(
          children: [
            const SpaceH14(),
            Row(
              children: [
                Text(
                  intl.invest_period,
                  style: STStyles.header1Invest,
                ),
                const Spacer(),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Center(
                    child: SIconButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      defaultIcon: SCloseIcon(
                        color: SColorsLight().black,
                      ),
                      pressedIcon: SCloseIcon(
                        color: SColorsLight().black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SpaceH13(),
          ],
        ),
      ),
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [PeriodSheet(onConfirm: onConfirm, activePeriod: activePeriod)],
  );
}

class PeriodSheet extends StatefulObserverWidget {
  const PeriodSheet({
    required this.onConfirm,
    required this.activePeriod,
  });

  final Function(InvestHistoryPeriod value) onConfirm;
  final InvestHistoryPeriod activePeriod;

  @override
  State<StatefulWidget> createState() => _PeriodSheetState();
}

class _PeriodSheetState extends State<PeriodSheet> {
  late InvestHistoryPeriod period;

  @override
  void initState() {
    period = widget.activePeriod;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SPaddingH24(
      child: Observer(
        builder: (BuildContext context) {

          return Column(
            children: [
              Text(
                intl.invest_period_description,
                maxLines: 5,
                style: STStyles.body3InvestM,
              ),
              const SpaceH16(),
              Row(
                children: [
                  BitOfTap(
                    value: '7 ${intl.invest_period_days}',
                    onTap: () {
                      setState(() {
                        period = InvestHistoryPeriod.week;
                      });
                    },
                    isActive: period == InvestHistoryPeriod.week,
                  ),
                  const Spacer(),
                  BitOfTap(
                    value: '30 ${intl.invest_period_days}',
                    onTap: () {
                      setState(() {
                        period = InvestHistoryPeriod.oneMonth;
                      });
                    },
                    isActive: period == InvestHistoryPeriod.oneMonth,
                  ),
                  const Spacer(),
                  BitOfTap(
                    value: '60 ${intl.invest_period_days}',
                    onTap: () {
                      setState(() {
                        period = InvestHistoryPeriod.twoMonth;
                      });
                    },
                    isActive: period == InvestHistoryPeriod.twoMonth,
                  ),
                  const Spacer(),
                  BitOfTap(
                    value: '90 ${intl.invest_period_days}',
                    onTap: () {
                      setState(() {
                        period = InvestHistoryPeriod.threeMonth;
                      });
                    },
                    isActive: period == InvestHistoryPeriod.threeMonth,
                  ),
                ],
              ),
              // const SpaceH12(),
              // Container(
              //   height: 32,
              //   width: MediaQuery.of(context).size.width - 48,
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(24),
              //     color: colors.grey5,
              //   ),
              //   child: Center(
              //     child: Text(
              //       '${DateFormat('yyyy.MM.dd ', intl.localeName).format(
              //           DateTime.now().subtract(
              //             Duration(
              //               days: getDaysByPeriod(investStore.period),
              //             ),
              //           ),
              //       )}'
              //       '-'
              //       '${DateFormat('yyyy.MM.dd ', intl.localeName).format(DateTime.now())}',
              //       style: sBody2InvestSMStyle.copyWith(
              //         color: colors.black,
              //         height: 1,
              //       ),
              //     ),
              //   ),
              // ),
              const SpaceH16(),
              SizedBox(
                height: 98.0,
                child: Column(
                  children: [
                    const SpaceH20(),
                    Row(
                      children: [
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().grey5,
                            activeNameColor: SColorsLight().black,
                            inactiveColor: SColorsLight().grey5,
                            inactiveNameColor: SColorsLight().black,
                            active: true,
                            name: intl.invest_cancel,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SpaceW10(),
                        Expanded(
                          child: SIButton(
                            activeColor: SColorsLight().blue,
                            activeNameColor: SColorsLight().white,
                            inactiveColor: SColorsLight().grey4,
                            inactiveNameColor: SColorsLight().grey2,
                            active: true,
                            name: intl.invest_confirm,
                            onTap: () {
                              widget.onConfirm(period);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SpaceH34(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
