import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionButtons extends StatelessWidget {
  const CircleActionButtons({
    super.key,
    this.isBuyDisabled = false,
    this.isSellDisabled = false,
    this.isReceiveDisabled = false,
    this.isSendDisabled = false,
    this.isConvertDisabled = false,
    this.onBuy,
    this.onSell,
    this.onReceive,
    this.onSend,
    this.onConvert,
  });

  final bool isBuyDisabled;
  final bool isSellDisabled;
  final bool isReceiveDisabled;
  final bool isSendDisabled;
  final bool isConvertDisabled;
  final Function()? onBuy;
  final Function()? onSell;
  final Function()? onReceive;
  final Function()? onSend;
  final Function()? onConvert;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SPaddingH24(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: ActionPannel(
          actionButtons: [
            SActionButton(
              icon: Assets.svg.medium.add.simpleSvg(
                color: colors.white,
              ),
              state: isBuyDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
              onTap: () {
                onBuy?.call();
              },
              lable: intl.balanceActionButtons_buy,
            ),
            SActionButton(
              onTap: () {
                onSell?.call();
              },
              lable: intl.operationName_sell,
              icon: Assets.svg.medium.remove.simpleSvg(
                color: SColorsLight().white,
              ),
              state: isSellDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
            ),
            SActionButton(
              onTap: () {
                onSend?.call();
              },
              lable: intl.balanceActionButtons_send,
              icon: Assets.svg.medium.arrowUp.simpleSvg(
                color: SColorsLight().white,
              ),
              state: isSendDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
            ),
            SActionButton(
              onTap: () {
                onReceive?.call();
              },
              lable: intl.balanceActionButtons_receive,
              icon: Assets.svg.medium.arrowDown.simpleSvg(
                color: SColorsLight().white,
              ),
              state: isReceiveDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
            ),
            SActionButton(
              icon: Assets.svg.medium.transfer.simpleSvg(
                color: SColorsLight().white,
              ),
              state: isConvertDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
              onTap: () {
                onConvert?.call();
              },
              lable: intl.convert_convert,
            ),
          ],
        ),
      ),
    );
  }
}
