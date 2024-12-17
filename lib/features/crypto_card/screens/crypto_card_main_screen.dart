import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_action_buttons.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_add_to_wallet_banner.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_amount_widget.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_widget.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'CryptoCardMainRoute')
class CryptoCardMainScreen extends StatelessWidget {
  const CryptoCardMainScreen({
    required this.cryptoCard,
    super.key,
  });

  final CryptoCardModel cryptoCard;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('crypto-card-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'crypto-card-screen-key',
                event: sAnalytics.viewMainCardScreen,
              );
        }
      },
      child: Provider(
        create: (context) => MainCryptoCardStore()..init(),
        child: const _CryptoCardMainScreenBody(),
      ),
    );
  }
}

class _CryptoCardMainScreenBody extends StatefulWidget {
  const _CryptoCardMainScreenBody();

  @override
  State<_CryptoCardMainScreenBody> createState() => _CryptoCardMainScreenBodyState();
}

class _CryptoCardMainScreenBodyState extends State<_CryptoCardMainScreenBody> {
  bool showViewAllButtonOnHistory = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainCryptoCardStore>(context);

    return Observer(
      builder: (context) {
        final cryptoCard = store.cryptoCard;
        final cardIsFrozen = cryptoCard.status == CryptoCardStatus.frozen;

        return SPageFrame(
          loaderText: intl.register_pleaseWait,
          header: GlobalBasicAppBar(
            title: intl.crypto_card_main_title,
            subtitle: cryptoCard.label,
            hasLeftIcon: false,
            hasRightIcon: false,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CryptoCardWidget(
                  isFrozen: cardIsFrozen,
                  last4: cryptoCard.last4,
                ),
              ),
              const SliverToBoxAdapter(
                child: CryptoCardAmountWidget(),
              ),
              SliverToBoxAdapter(
                child: CryptoCardActionButtons(
                  store: store,
                  cardIsFrozen: cardIsFrozen,
                ),
              ),
              const SliverToBoxAdapter(
                child: CryptoCardAddToWalletBanner(),
              ),
              SliverToBoxAdapter(
                child: SBasicHeader(
                  title: intl.crypto_card_history_transactions,
                  buttonTitle: intl.crypto_card_history_view_all,
                  showLinkButton: showViewAllButtonOnHistory,
                  onTap: () {
                    sRouter.push(
                      CryptoCardTransactionHistoryRoute(
                        cardId: cryptoCard.cardId,
                      ),
                    );
                  },
                ),
              ),
              TransactionsList(
                scrollController: ScrollController(),
                symbol: '_DEBUG_',
                onItemTapLisener: (symbol) {},
                source: TransactionItemSource.cryptoCard,
                mode: TransactionListMode.preview,
                onData: (items) {
                  if (items.length >= 5) {
                    if (!showViewAllButtonOnHistory) {
                      setState(() {
                        showViewAllButtonOnHistory = true;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
