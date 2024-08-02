import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../core/l10n/i10n.dart';

class MainSwitch extends StatelessObserverWidget {
  const MainSwitch({
    super.key,
    required this.onChangeTab,
    required this.activeTab,
  });

  final Function(int) onChangeTab;
  final int activeTab;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    void changeActiveTab(int newValue) {
      onChangeTab(newValue);
    }

    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colors.grey5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    changeActiveTab(0);
                  },
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 3,
                    child: Center(
                      child: Text(
                        intl.invest_switch_active,
                        style: STStyles.body1InvestSM.copyWith(
                          color: colors.grey1,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    changeActiveTab(1);
                  },
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 3,
                    child: Center(
                      child: Text(
                        intl.invest_switch_pending,
                        style: STStyles.body1InvestSM.copyWith(
                          color: colors.grey1,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    changeActiveTab(2);
                  },
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 3,
                    child: Center(
                      child: Text(
                        intl.invest_switch_history,
                        style: STStyles.body1InvestSM.copyWith(
                          color: colors.grey1,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (activeTab == 0)
          Positioned(
            left: 0,
            child: Container(
              width: (MediaQuery.of(context).size.width - 48) / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    intl.invest_switch_active,
                    style: STStyles.body1InvestSM.copyWith(
                      color: colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          )
        else if (activeTab == 1)
          Positioned(
            left: (MediaQuery.of(context).size.width - 48) / 3,
            child: Container(
              width: (MediaQuery.of(context).size.width - 48) / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    intl.invest_switch_pending,
                    style: STStyles.body1InvestSM.copyWith(
                      color: colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Positioned(
            right: 0,
            child: Container(
              width: (MediaQuery.of(context).size.width - 48) / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    intl.invest_switch_history,
                    style: STStyles.body1InvestSM.copyWith(
                      color: colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
