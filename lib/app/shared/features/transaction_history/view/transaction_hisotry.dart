import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../recurring/notifier/recurring_buys_notipod.dart';
import '../../recurring/view/recurring_buy_banner.dart';
import '../../wallet/view/components/wallet_body/components/transactions_list/transactions_list.dart';

class TransactionHistory extends HookWidget {
  TransactionHistory({
    Key? key,
    this.assetName,
    this.assetSymbol,
  }) : super(key: key);

  final String? assetName;
  final String? assetSymbol;

  /// TODO(Vova) reconsider this
  final scrollController = ScrollController();

  static void push({
    String? assetName,
    String? assetSymbol,
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      TransactionHistory(
        assetName: assetName,
        assetSymbol: assetSymbol,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final notifier = useProvider(recurringBuysNotipod.notifier);

    return Material(
      color: colors.white,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
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
                title: _title(),
              ),
            ),
          ),
          RecurringBuyBanner(
            type: notifier.typeByAllRecurringBuys(),
            totalRecurringBuy: notifier.totalByAllRecurring(),
            onTap: () {
              notifier.handleNavigate(context);
            },
          ),
          TransactionsList(
            scrollController: scrollController,
            errorBoxPaddingMultiplier: 0.313,
          ),
        ],
      ),
    );
  }

  String _title() {
    if (assetName != null && assetSymbol != null) {
      return 'History $assetName ($assetSymbol)';
    } else {
      return 'History';
    }
  }
}
