import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/32x32/public/market/simple_market_icon.dart';
import 'package:simple_kit/modules/icons/32x32/public/card_bottom/simple_card_bottom_icon.dart';
import 'package:simple_kit/modules/icons/32x32/public/wallets/simple_wallets_icon.dart';

import '../../simple_kit.dart';
import 'components/notification_box.dart';

class SBottomNavigationBar extends StatefulWidget {
  const SBottomNavigationBar({
    super.key,
    required this.cardNotifications,
    this.portfolioNotifications = 0,
    required this.showReward,
    required this.selectedIndex,
    required this.onChanged,
    required this.walletsText,
    required this.marketText,
    required this.investText,
    required this.accountText,
    required this.cardText,
    required this.rewardText,
    required this.showCard,
    required this.isCardRequested,
    this.rewardCount = 0,
    required this.showInvest,
  });

  final int portfolioNotifications;
  final int selectedIndex;
  final bool cardNotifications;
  final bool showCard;
  final bool isCardRequested;
  final bool showReward;
  final bool showInvest;
  final void Function(int) onChanged;

  final String walletsText;
  final String marketText;
  final String accountText;
  final String cardText;
  final String rewardText;
  final String investText;

  final int rewardCount;

  @override
  State<SBottomNavigationBar> createState() => _SBottomNavigationBarState();
}

class _SBottomNavigationBarState extends State<SBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColorsLight().white,
      child: SizedBox(
        height: 99.0,
        child: Column(
          children: [
            const SDivider(),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 5,
                  height: 62,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SpaceH11(),
                        if (widget.selectedIndex == 0) const SWalletsActiveIcon() else const SWalletsIcon(),
                        const SpaceH4(),
                        Text(
                          widget.walletsText,
                          style: sBodyText2Style.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                            color: widget.selectedIndex == 0 ? SColorsLight().black : SColorsLight().grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 5,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(1),
                    child: Column(
                      children: [
                        const SpaceH11(),
                        if (widget.selectedIndex == 1) const SMarketActiveIcon() else const SMarketIcon(),
                        Text(
                          widget.marketText,
                          style: sBodyText2Style.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                            color: widget.selectedIndex == 1 ? SColorsLight().black : SColorsLight().grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.showInvest) ...[
                  const Spacer(),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 5,
                    child: STransparentInkWell(
                      onTap: () => widget.onChanged(2),
                      child: Column(
                        children: [
                          const SpaceH11(),
                          if (widget.selectedIndex == 2) const SMarketActiveIcon() else const SMarketIcon(),
                          Text(
                            widget.investText,
                            style: sBodyText2Style.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              color: widget.selectedIndex == 2 ? SColorsLight().black : SColorsLight().grey3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (widget.showCard) ...[
                  const Spacer(),
                  Stack(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 5,
                        child: STransparentInkWell(
                          onTap: () => widget.onChanged(3),
                          child: Column(
                            children: [
                              const SpaceH11(),
                              if (widget.selectedIndex == 3) const SCardBottomActiveIcon() else const SCardBottomIcon(),
                              Text(
                                widget.cardText,
                                style: sBodyText2Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.38,
                                  color: widget.selectedIndex == 3 ? SColorsLight().black : SColorsLight().grey3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: (MediaQuery.of(context).size.width - 48) / 8 - 36,
                        top: -2,
                        child: NotificationBox(
                          notifications: widget.isCardRequested ? 0 : 1,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                if (widget.showReward) ...[
                  Stack(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 5,
                        child: STransparentInkWell(
                          onTap: () => widget.onChanged(4),
                          child: Column(
                            children: [
                              const SpaceH15(),
                              if (widget.selectedIndex == 4)
                                const SRewardIcon()
                              else
                                SRewardIcon(
                                  color: SColorsLight().grey3,
                                ),
                              const SpaceH4(),
                              Text(
                                widget.rewardText,
                                style: sBodyText2Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.38,
                                  color: widget.selectedIndex == 4 ? SColorsLight().black : SColorsLight().grey3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: (MediaQuery.of(context).size.width - 48) / 8 - 28,
                        top: -2,
                        child: NotificationBox(
                          notifications: widget.rewardCount,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
