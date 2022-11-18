import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_amount_cursor.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_auto_size_amount.dart';
import 'package:jetwallet/features/convert/ui/widgets/widgets/convert_dropdown_button.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

class ConvertRow extends StatefulObserverWidget {
  const ConvertRow({
    Key? key,
    this.fromAsset = false,
    this.inputError,
    required this.value,
    required this.onTap,
    required this.enabled,
    required this.currency,
    required this.assetWithBalance,
    required this.assetWithoutBalance,
    required this.onDropdown,
  }) : super(key: key);

  final bool fromAsset;
  final InputError? inputError;
  final String value;
  final Function() onTap;
  final bool enabled;
  final CurrencyModel currency;
  final List<CurrencyModel> assetWithBalance;
  final List<CurrencyModel> assetWithoutBalance;
  final Function(CurrencyModel?) onDropdown;

  @override
  State<ConvertRow> createState() => _ConvertRowState();
}

class _ConvertRowState extends State<ConvertRow>
    with SingleTickerProviderStateMixin {
  late AnimationController cursorAnimation;

  @override
  void initState() {
    super.initState();
    cursorAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    cursorAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    void _showDropdownSheet() {
      sShowBasicModalBottomSheet(
        context: context,
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: widget.fromAsset ? intl.from : intl.to1,
        ),
        children: [
          for (final item in widget.assetWithBalance)
            SAssetItem(
              isSelected: widget.currency == item,
              icon: SNetworkSvg24(
                url: item.iconUrl,
                color: _iconColor(item, context),
              ),
              name: item.description,
              description: item.symbol,
              amount: item.volumeBaseBalance(baseCurrency),
              divider: item != widget.assetWithBalance.last,
              onTap: () {
                if (widget.currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
            ),
          for (final item in widget.assetWithoutBalance)
            SAssetItem(
              isSelected: widget.currency == item,
              icon: SNetworkSvg24(
                url: item.iconUrl,
                color: _iconColor(item, context),
              ),
              name: item.description,
              description: item.symbol,
              amount: item.volumeBaseBalance(baseCurrency),
              divider: item != widget.assetWithoutBalance.last,
              onTap: () {
                if (widget.currency == item) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, item);
                }
              },
            ),
        ],
        then: (value) {
          if (value is CurrencyModel) {
            widget.onDropdown(value);
          }
        },
      );
    }

    return SPaddingH24(
      child: Stack(
        children: [
          SizedBox(
            height: 88.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH22(),
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      ConvertDropdownButton(
                        onTap: () => _showDropdownSheet(),
                        currency: widget.currency,
                      ),
                      ConvertAutoSizeAmount(
                        onTap: widget.onTap,
                        value: widget.value,
                        enabled: widget.enabled,
                      ),
                      if (widget.enabled) ...[
                        if (cursorAnimation.value > 0.5)
                          const ConvertAmountCursor()
                        else
                          const ConvertAmountCursorPlaceholder(),
                      ] else
                        const ConvertAmountCursorPlaceholder(),
                    ],
                  ),
                ),
                Baseline(
                  baseline: 16.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    children: [
                      const SpaceW34(),
                      if (widget.inputError == null ||
                          widget.inputError == InputError.none)
                        Text(
                          '${intl.convertRow_available}:'
                          ' ${widget.currency.volumeAssetBalance}',
                          maxLines: 1,
                          style: sBodyText2Style.copyWith(
                            color: colors.grey2,
                          ),
                        )
                      else ...[
                        const Spacer(),
                        Text(
                          widget.inputError!.value(),
                          maxLines: 1,
                          style: sSubtitle3Style.copyWith(
                            color: colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color? _iconColor(CurrencyModel item, BuildContext context) {
    final colors = sKit.colors;

    if (item.type == AssetType.indices) {
      return null;
    }

    if (item.symbol == 'CPWR') {
      return null;
    }

    return widget.currency == item ? colors.blue : colors.black;
  }
}
