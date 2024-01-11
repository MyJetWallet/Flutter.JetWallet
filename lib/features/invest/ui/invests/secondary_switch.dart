import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/invest/ui/widgets/invest_carousel.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/l10n/i10n.dart';

class SecondarySwitch extends StatelessObserverWidget {
  const SecondarySwitch({
    super.key,
    required this.onChangeTab,
    required this.activeTab,
    required this.tabs,
    this.tabsAssets = const [],
    this.fromRight = true,
    this.fullWidth = true,
  });

  final Function(int) onChangeTab;
  final int activeTab;
  final List<String> tabs;
  final bool fromRight;
  final bool fullWidth;
  final List<Widget> tabsAssets;

  @override
  Widget build(BuildContext context) {

    final colors = sKit.colors;

    void changeActiveTab(int newValue) {
      onChangeTab(newValue);
    }

    return SizedBox(
      width: fullWidth ? MediaQuery.of(context).size.width - 48 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: fromRight
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
          children: [
            if (fullWidth)
              InvestCarousel(
                height: 24,
                margin: 0,
                isSwitch: true,
                children: [
                  for (var i = 0; i < tabs.length; i++) ...[
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        changeActiveTab(i);
                      },
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: activeTab == i ? colors.grey5 : colors.white,
                        ),
                        child: Center(
                          child: Text(
                            tabs[i],
                            style: sBody2InvestSMStyle.copyWith(
                              color: activeTab == i ? colors.black : colors.grey1,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            else ...[
              for (var i = 0; i < tabs.length; i++) ...[
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    changeActiveTab(i);
                  },
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: activeTab == i ? colors.grey5 : colors.white,
                    ),
                    child: Center(
                      child: Text(
                        tabs[i],
                        style: sBody2InvestSMStyle.copyWith(
                          color: activeTab == i ? colors.black : colors.grey1,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (tabsAssets.isNotEmpty) ...[
                for (var i = 0; i < tabsAssets.length; i++) ...[
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      changeActiveTab(i);
                    },
                    child: Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: activeTab == i ? colors.grey5 : colors.white,
                      ),
                      child: Center(
                        child: tabsAssets[i],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}
