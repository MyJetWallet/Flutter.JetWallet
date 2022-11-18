import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/widgets/bottom_tabs/bottom_tabs.dart';
import 'package:jetwallet/widgets/bottom_tabs/components/bottom_tab.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../wallet/helper/nft_types.dart';
import '../../wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_main_list.dart';

class TransactionHistory extends StatelessObserverWidget {
  const TransactionHistory({
    Key? key,
    this.assetName,
    this.assetSymbol,
    this.initialIndex = 0,
  }) : super(key: key);

  final String? assetName;
  final String? assetSymbol;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;
    final scrollController = ScrollController();

    final showCrypto = sSignalRModules.nftList.isNotEmpty;

    return Scaffold(
      body: DefaultTabController(
        length: showCrypto ? 3 : 2,
        initialIndex: initialIndex,
        child: Scaffold(
          backgroundColor: colors.white,
          body: Stack(
            children: [
              TabBarView(
                children: [
                  NestedScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverAppBar(
                          toolbarHeight: deviceSize.when(
                            small: () {
                              return 80;
                            },
                            medium: () {
                              return 60;
                            },
                          ),
                          pinned: true,
                          backgroundColor: colors.white,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          flexibleSpace: SPaddingH24(
                            child: SSmallHeader(
                              title: _title(context, TransactionType.none),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                      child: TransactionsMainList(
                        scrollController: scrollController,
                        symbol: assetSymbol,
                      ),
                    ),
                  ),
                  NestedScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverAppBar(
                          toolbarHeight: deviceSize.when(
                            small: () {
                              return 80;
                            },
                            medium: () {
                              return 60;
                            },
                          ),
                          pinned: true,
                          backgroundColor: colors.white,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          flexibleSpace: SPaddingH24(
                            child: SSmallHeader(
                              title: _title(context, TransactionType.crypto),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                      child: TransactionsMainList(
                        scrollController: scrollController,
                        symbol: assetSymbol,
                        filter: TransactionType.crypto,
                      ),
                    ),
                  ),
                  NestedScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverAppBar(
                          toolbarHeight: deviceSize.when(
                            small: () {
                              return 80;
                            },
                            medium: () {
                              return 60;
                            },
                          ),
                          pinned: true,
                          backgroundColor: colors.white,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          flexibleSpace: SPaddingH24(
                            child: SSmallHeader(
                              title: _title(context, TransactionType.nft),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Container(
                      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                      child: TransactionsMainList(
                        scrollController: scrollController,
                        symbol: assetSymbol,
                        filter: TransactionType.nft,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: BottomTabs(
                  bottomPadding: 16,
                  tabs: [
                    BottomTab(text: intl.market_all),
                    BottomTab(text: intl.market_crypto),
                    if (showCrypto) ...[
                      BottomTab(
                        text: intl.market_nft,
                        isTextBlue: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context, TransactionType type) {
    return assetName != null && assetSymbol != null
        ? '${intl.transactionHistory_history} $assetName ($assetSymbol)'
        : type == TransactionType.none
            ? intl.transactionHistory_history
            : type == TransactionType.crypto
                ? intl.nft_history_crypto
                : intl.nft_history_nft;
  }
}

class _TransactionHistoryBody extends StatelessObserverWidget {
  const _TransactionHistoryBody({
    super.key,
    required this.scrollController,
    this.assetSymbol,
  });

  final ScrollController scrollController;
  final String? assetSymbol;

  @override
  Widget build(BuildContext context) {
    final showCrypto = sSignalRModules.nftList.isNotEmpty;

    return Scaffold(
      body: DefaultTabController(
        initialIndex: 1,
        length: showCrypto ? 3 : 2,
        child: Stack(
          children: [
            TabBarView(
              children: [
                TransactionsList(
                  scrollController: scrollController,
                  symbol: assetSymbol,
                ),
                TransactionsList(
                  scrollController: scrollController,
                  symbol: assetSymbol,
                ),
                TransactionsList(
                  scrollController: scrollController,
                  symbol: assetSymbol,
                ),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomTabs(
                tabs: [
                  BottomTab(
                    text: intl.market_all,
                  ),
                  BottomTab(text: intl.market_crypto),
                  if (showCrypto) ...[
                    BottomTab(
                      text: intl.market_nft,
                      isTextBlue: true,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
