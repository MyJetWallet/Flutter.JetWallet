import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionHistory extends StatelessObserverWidget {
  const TransactionHistory({
    Key? key,
    this.assetName,
    this.assetSymbol,
  }) : super(key: key);

  final String? assetName;
  final String? assetSymbol;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;
    final scrollController = ScrollController();

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
                title: _title(context),
              ),
            ),
          ),
          TransactionsList(
            scrollController: scrollController,
            symbol: assetSymbol,
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    return assetName != null && assetSymbol != null
        ? '${intl.transactionHistory_history} $assetName ($assetSymbol)'
        : intl.transactionHistory_history;
  }
}
