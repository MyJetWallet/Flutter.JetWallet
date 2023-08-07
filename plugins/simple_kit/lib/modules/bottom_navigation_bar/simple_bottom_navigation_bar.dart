import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/32x32/public/market/simple_market_icon.dart';
import 'package:simple_kit/modules/icons/32x32/public/my_assets/simple_my_assets_icon.dart';
import 'package:simple_kit/modules/icons/32x32/public/card_bottom/simple_card_bottom_icon.dart';
import 'package:simple_kit/modules/icons/32x32/public/account_bar/simple_account_bar_icon.dart';

import '../../simple_kit.dart';
import 'components/notification_box.dart';

class SBottomNavigationBar extends StatefulWidget {
  const SBottomNavigationBar({
    Key? key,
    required this.cardNotifications,
    this.portfolioNotifications = 0,
    required this.selectedIndex,
    required this.onChanged,
    required this.myAssetsText,
    required this.marketText,
    required this.accountText,
    required this.cardText,
    required this.rewardText,
    required this.hideAccount,
    required this.showCard,
    required this.isCardRequested,
  }) : super(key: key);

  final int portfolioNotifications;
  final int selectedIndex;
  final bool cardNotifications;
  final bool hideAccount;
  final bool showCard;
  final bool isCardRequested;
  final void Function(int) onChanged;

  final String myAssetsText;
  final String marketText;
  final String accountText;
  final String cardText;
  final String rewardText;

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
                  width: (MediaQuery.of(context).size.width - 48) / 4,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(0),
                    child: Column(
                      children: [
                        const SpaceH11(),
                        if (widget.selectedIndex == 0)
                          const SMyAssetsActiveIcon()
                        else
                          const SMyAssetsIcon(),
                        Text(
                          widget.myAssetsText,
                          style: sBodyText2Style.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                            color: widget.selectedIndex == 0
                                ? SColorsLight().black
                                : SColorsLight().grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 4,
                  child: STransparentInkWell(
                    onTap: () => widget.onChanged(1),
                    child: Column(
                      children: [
                        const SpaceH11(),
                        if (widget.selectedIndex == 1)
                          const SMarketActiveIcon()
                        else
                          const SMarketIcon(),
                        Text(
                          widget.marketText,
                          style: sBodyText2Style.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                            color: widget.selectedIndex == 1
                                ? SColorsLight().black
                                : SColorsLight().grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!widget.hideAccount) ...[
                  const Spacer(),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 4,
                    child: STransparentInkWell(
                      onTap: () => widget.onChanged(2),
                      child: Column(
                        children: [
                          const SpaceH11(),
                          if (widget.selectedIndex == 2)
                            const SAccountBarActiveIcon()
                          else
                            const SAccountBarIcon(),
                          Text(
                            widget.accountText,
                            style: sBodyText2Style.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              color: widget.selectedIndex == 2
                                  ? SColorsLight().black
                                  : SColorsLight().grey3,
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
                        width: (MediaQuery.of(context).size.width - 48) / 4,
                        child: STransparentInkWell(
                          onTap: () => widget.onChanged(3),
                          child: Column(
                            children: [
                              const SpaceH11(),
                              if (widget.selectedIndex == 3)
                                const SCardBottomActiveIcon()
                              else
                                const SCardBottomIcon(),
                              Text(
                                widget.cardText,
                                style: sBodyText2Style.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.38,
                                  color: widget.selectedIndex == 3
                                      ? SColorsLight().black
                                      : SColorsLight().grey3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      NotificationBox(
                        notifications: widget.isCardRequested ? 0 : 1,
                        top: -2,
                        right:
                            (MediaQuery.of(context).size.width - 48) / 8 - 29,
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                Stack(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 4,
                      child: STransparentInkWell(
                        onTap: () => widget.onChanged(3),
                        child: Column(
                          children: [
                            const SpaceH11(),
                            if (widget.selectedIndex == 3)
                              const SRewardIcon()
                            else
                              const SRewardIcon(),
                            Text(
                              widget.rewardText,
                              style: sBodyText2Style.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.38,
                                color: widget.selectedIndex == 3
                                    ? SColorsLight().black
                                    : SColorsLight().grey3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    NotificationBox(
                      notifications: widget.isCardRequested ? 0 : 1,
                      top: -2,
                      right: (MediaQuery.of(context).size.width - 48) / 8 - 29,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
