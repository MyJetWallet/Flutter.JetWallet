import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_limits_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/limits_crypto_card_response_model.dart';

@RoutePage(name: 'CryptoCardLimitsRoute')
class CryptoCardLimitsScreen extends StatefulWidget {
  const CryptoCardLimitsScreen({super.key, required this.cardId});

  final String cardId;

  @override
  State<CryptoCardLimitsScreen> createState() => _CryptoCardLimitsScreenState();
}

class _CryptoCardLimitsScreenState extends State<CryptoCardLimitsScreen> {
  @override
  void initState() {
    super.initState();
    sAnalytics.viewLimitsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardLimitsStore(cardId: widget.cardId)..loadLimits(),
      builder: (context, child) {
        final store = CryptoCardLimitsStore.of(context);

        return SPageFrame(
          loaderText: '',
          header: GlobalBasicAppBar(
            hasRightIcon: false,
            title: intl.crypto_card_limits,
          ),
          child: Observer(
            builder: (context) {
              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child:
                        store.limits != null ? _CryptoCardLoadedLimits(limits: store.limits!) : const _LoadingState(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _CryptoCardLoadedLimits extends StatelessWidget {
  _CryptoCardLoadedLimits({required this.limits});

  final LimitsCryptoCardResponseModel limits;

  final asset = getIt.get<FormatService>().findCurrency(
        assetSymbol: 'EUR',
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        STextDivider(intl.crypto_card_limits_card_payments),
        SimpleHistoryTable(
          label: intl.crypto_card_limits_daily,
          value: _formatAmount(limits.purchaseDailyLimit),
          rightSupplement:
              intl.crypto_card_limits_left(_formatAmount(limits.purchaseDailyLimit - limits.purchaseDailyUsed)),
        ),
        SimpleHistoryTable(
          label: intl.crypto_card_limits_weekly,
          value: _formatAmount(limits.purchaseWeeklyLimit),
          rightSupplement:
              intl.crypto_card_limits_left(_formatAmount(limits.purchaseWeeklyLimit - limits.purchaseWeeklyUsed)),
        ),
        SimpleHistoryTable(
          label: intl.crypto_card_monthly,
          value: _formatAmount(limits.purchaseMonthlyLimit),
          rightSupplement:
              intl.crypto_card_limits_left(_formatAmount(limits.purchaseMonthlyLimit - limits.purchaseMonthlyUsed)),
        ),
        STextDivider(intl.crypto_card_limits_atm_withdrawals),
        SimpleHistoryTable(
          label: intl.crypto_card_limits_daily,
          value: _formatAmount(limits.atmDailyLimit),
          rightSupplement: intl.crypto_card_limits_left(_formatAmount(limits.atmDailyLimit - limits.atmDailyUsed)),
        ),
        SimpleHistoryTable(
          label: intl.crypto_card_limits_weekly,
          value: _formatAmount(limits.atmWeeklyLimit),
          rightSupplement: intl.crypto_card_limits_left(_formatAmount(limits.atmWeeklyLimit - limits.atmWeeklyUsed)),
        ),
        SimpleHistoryTable(
          label: intl.crypto_card_monthly,
          value: _formatAmount(limits.atmMonthlyLimit),
          rightSupplement: intl.crypto_card_limits_left(_formatAmount(limits.atmMonthlyLimit - limits.atmMonthlyUsed)),
        ),
      ],
    );
  }

  String _formatAmount(Decimal amount) {
    return amount.toFormatCount(
      symbol: asset.symbol,
      accuracy: asset.accuracy,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextLoader(),
        _ItemLoader(),
        _ItemLoader(),
        _ItemLoader(),
        _TextLoader(),
        _ItemLoader(),
        _ItemLoader(),
        _ItemLoader(),
      ],
    );
  }
}

class _TextLoader extends StatelessWidget {
  const _TextLoader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 24,
        bottom: 4,
      ),
      child: SSkeletonLoader(
        width: 132,
        height: 12,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _ItemLoader extends StatelessWidget {
  const _ItemLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          SSkeletonLoader(
            width: 80,
            height: 24,
            borderRadius: BorderRadius.circular(4),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SSkeletonLoader(
                width: 80,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
              const SpaceH8(),
              SSkeletonLoader(
                width: 48,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
