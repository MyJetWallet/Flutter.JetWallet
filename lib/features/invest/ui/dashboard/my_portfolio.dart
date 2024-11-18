import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import '../../../../core/l10n/i10n.dart';
import '../../../../utils/models/currency_model.dart';

class MyPortfolio extends StatelessObserverWidget {
  const MyPortfolio({
    super.key,
    required this.title,
    required this.pending,
    required this.amount,
    required this.balance,
    required this.percent,
    required this.onShare,
    required this.currency,
    required this.onTap,
  });

  final String title;
  final Decimal pending;
  final Decimal amount;
  final Decimal balance;
  final Decimal percent;
  final Function() onShare;
  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH9(),
              Row(
                children: [
                  Text(
                    title,
                    style: STStyles.header2Invest.copyWith(
                      color: colors.black,
                    ),
                  ),
                  const SpaceW5(),
                ],
              ),
              const SpaceH4(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.invest_amount,
                        style: STStyles.body3InvestM.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.network(
                            currency.iconUrl,
                            width: 10.0,
                            height: 10.0,
                            placeholderBuilder: (_) {
                              return const SAssetPlaceholderIcon();
                            },
                          ),
                          const SpaceW2(),
                          Text(
                            getIt<AppStore>().isBalanceHide ? '****' : amount.toFormatSum(accuracy: 2),
                            style: STStyles.body3InvestSM.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceW12(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.invest_pending,
                        style: STStyles.body3InvestM.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.network(
                            currency.iconUrl,
                            width: 10.0,
                            height: 10.0,
                            placeholderBuilder: (_) {
                              return const SAssetPlaceholderIcon();
                            },
                          ),
                          const SpaceW2(),
                          Text(
                            getIt<AppStore>().isBalanceHide ? '****' : pending.toFormatSum(accuracy: 2),
                            style: STStyles.body3InvestSM.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SpaceH9(),
            ],
          ),
          const Spacer(),
          Container(
            width: 126,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment(1.0, 3.0),
                end: Alignment(-1.0, -3.0),
                colors: [
                  Color(0xFFE8F9E8),
                  Color(0xFFC0E6C6),
                  Color(0xFFDFF7B6),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.network(
                      currency.iconUrl,
                      width: 16.0,
                      height: 16.0,
                      placeholderBuilder: (_) {
                        return const SAssetPlaceholderIcon();
                      },
                    ),
                    const SpaceW4(),
                    Text(
                      getIt<AppStore>().isBalanceHide ? '****' : balance.toFormatSum(accuracy: 2),
                      style: STStyles.header3Invest.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
                const SpaceH2(),
                Text(
                  percent.toDouble().toFormatPercentPriceChange(),
                  style: STStyles.body1InvestSM.copyWith(
                    color: colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
