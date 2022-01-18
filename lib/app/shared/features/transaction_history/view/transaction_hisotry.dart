import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../wallet/view/components/wallet_body/components/transactions_list/transactions_list.dart';

class TransactionHistory extends HookWidget {
  TransactionHistory({
    Key? key,
    this.assetId,
    this.assetName,
  }) : super(key: key);

  final String? assetId;
  final String? assetName;
  final scrollController = ScrollController();

  static void push({
    String? assetId,
    String? assetName,
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      TransactionHistory(
        assetId: assetId,
        assetName: assetName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Material(
      color: colors.white,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
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
          TransactionsList(
            scrollController: scrollController,
            errorBoxPaddingMultiplier: 0.313,
            assetId: assetId,
          ),
        ],
      ),
    );
  }

  String _title() {
    if (assetName != null && assetId != null) {
      return 'History $assetName ($assetId)';
    } else {
      return 'History';
    }
  }
}
