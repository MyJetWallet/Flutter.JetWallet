import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../wallet/helper/nft_types.dart';
import '../../wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_main_list.dart';

@RoutePage(name: 'TransactionHistoryRouter')
class TransactionHistory extends StatelessObserverWidget {
  const TransactionHistory({
    super.key,
    this.assetName,
    this.assetSymbol,
    this.initialIndex = 0,
    this.jwOperationId,
  });

  final String? assetName;
  final String? assetSymbol;
  final int initialIndex;
  final String? jwOperationId;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;
    //final scrollController = ScrollController();

    return Scaffold(
      body: Scaffold(
        backgroundColor: colors.white,
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
          body: TransactionsMainList(
            zeroPadding: true,
            symbol: assetSymbol,
            jw_operation_id: jwOperationId,
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context, TransactionType type) {
    return intl.account_transactionHistory;
  }
}
