import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../screens/market/view/components/fade_on_scroll.dart';
import '../../../../../models/currency_model.dart';
import 'components/card_block/components/wallet_card.dart';
import 'components/card_block/components/wallet_card_collapsed.dart';
import 'components/transactions_list/transactions_list.dart';

const _collapsedCardHeight = 200.0;
const _expandedCardHeight = 270.0;

class WalletBody extends StatefulHookWidget {
  const WalletBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<StatefulWidget> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colors = useProvider(sColorPod);

    var walletBackground = walletGreenBackgroundImageAsset;

    if (!widget.currency.isGrowing) {
      walletBackground = walletRedBackgroundImageAsset;
    }

    return Material(
      color: colors.white,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _snapAppbar();
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              stretch: true,
              elevation: 0,
              expandedHeight: _expandedCardHeight,
              collapsedHeight: _collapsedCardHeight,
              automaticallyImplyLeading: false,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: _scrollController,
                fullOpacityOffset: 33,
                fadeInWidget: WalletCardCollapsed(
                  currency: widget.currency,
                ),
                fadeOutWidget: WalletCard(
                  currency: widget.currency,
                ),
                permanentWidget: Stack(
                  children: [
                    SvgPicture.asset(
                      walletBackground,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    SPaddingH24(
                      child: SSmallHeader(
                        title: '${widget.currency.description} wallet',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SPaddingH24(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH36(),
                    Text(
                      '${widget.currency.description} transactions',
                      style: sTextH4Style,
                    ),
                  ],
                ),
              ),
            ),
            TransactionsList(
              scrollController: _scrollController,
              symbol: widget.currency.symbol,
            ),
          ],
        ),
      ),
    );
  }

  void _snapAppbar() {
    const scrollDistance = _expandedCardHeight - _collapsedCardHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => _scrollController.animateTo(
          snapOffset.toDouble(),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
