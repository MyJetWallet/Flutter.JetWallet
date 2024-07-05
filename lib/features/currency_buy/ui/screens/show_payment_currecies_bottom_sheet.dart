import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../market/market_details/helper/currency_from_all.dart';

void showPaymentCurrenciesBottomSheet({
  required BuildContext context,
  required String header,
  required void Function(PaymentAsset) onTap,
  required PaymentAsset? activeAsset,
  required List<PaymentAsset> assets,
}) {
  final colors = sKit.colors;
  final currencies = sSignalRModules.currenciesWithHiddenList;
  final baseCurrency = sSignalRModules.baseCurrency;
  final iterableAssets = <CurrencyModel>[];
  final sortedAssets = List<PaymentAsset>.from(assets);
  if (sortedAssets.isNotEmpty) {
    sortedAssets.sort(
      (a, b) {
        if (a.asset == baseCurrency.symbol) {
          return 0.compareTo(1);
        } else if (b.asset == baseCurrency.symbol) {
          return 1.compareTo(0);
        }

        return (a.orderId ?? 0).compareTo(b.orderId ?? 0);
      },
    );
  }

  for (final asset in sortedAssets) {
    final currencyByAsset = currencyFromAll(currencies, asset.asset);
    iterableAssets.add(currencyByAsset);
  }

  return sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: header,
    ),
    horizontalPadding: 0,
    horizontalPinnedPadding: 24,
    children: [
      for (final asset in sortedAssets) ...[
        InkWell(
          onTap: () {
            onTap(asset);
          },
          splashColor: Colors.transparent,
          highlightColor: colors.grey5,
          hoverColor: Colors.transparent,
          child: SPaddingH24(
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 88,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 2,
                          color: asset.asset != activeAsset?.asset ? colors.black : colors.blue,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            iterableAssets[sortedAssets.indexOf(asset)].prefixSymbol ?? '?',
                            style: sCaptionTextStyle.copyWith(
                              color: asset.asset != activeAsset?.asset ? colors.black : colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        iterableAssets[sortedAssets.indexOf(asset)].description,
                        style: sSubtitle2Style.copyWith(
                          color: asset.asset != activeAsset?.asset ? colors.black : colors.blue,
                        ),
                      ),
                      const SpaceH4(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (asset != sortedAssets.last) const SPaddingH24(child: SDivider()),
      ],
      const SpaceH67(),
    ],
  );
}
