import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_address_info.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/change_order_widget.dart';
import 'package:jetwallet/features/my_wallets/widgets/get_account_button.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_asset_item.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:logger/logger.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/delete_asset/simple_delete_asset.dart';
import 'package:simple_kit/modules/icons/24x24/public/start_reorder/simple_start_reorder_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class AssetsListWidget extends StatefulObserverWidget {
  const AssetsListWidget({
    super.key,
    required this.store,
  });

  final MyWalletsSrore store;

  @override
  State<AssetsListWidget> createState() => _AssetsListWidgetState();
}

class _AssetsListWidgetState extends State<AssetsListWidget> {
  @override
  Widget build(BuildContext context) {
    final list = slidableItems();

    return Column(
      children: [
        if (widget.store.isReordering) ...[
          ChangeOrderWidget(
            onPressedDone: widget.store.onEndReordering,
          ),
          ReorderableListView(
            proxyDecorator: _proxyDecorator,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              var newIndexTemp = newIndex;

              if (oldIndex < newIndexTemp) {
                newIndexTemp -= 1;
              }
              final item = widget.store.currencies.removeAt(oldIndex);
              widget.store.currencies.insert(newIndexTemp, item);
              setState(() {});
            },
            children: list,
          ),
        ] else
          ...list,
      ],
    );
  }

  List<Widget> slidableItems() {
    final colors = sKit.colors;
    final list = <Widget>[];

    for (var index = 0; index < widget.store.currencies.length; index += 1) {
      list.add(
        Column(
          key: ValueKey(widget.store.currencies[index].symbol),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slidable(
              startActionPane: !widget.store.isReordering
                  ? ActionPane(
                      extentRatio: 0.2,
                      motion: const StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            widget.store.onStartReordering();
                          },
                          backgroundColor: colors.purple,
                          foregroundColor: colors.white,
                          child: SStartReorderIcon(
                            color: colors.white,
                          ),
                        ),
                      ],
                    )
                  : null,
              endActionPane: widget.store.currencies[index].isAssetBalanceEmpty
                  ? ActionPane(
                      extentRatio: 0.2,
                      motion: const StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            widget.store.onDelete(index);
                          },
                          backgroundColor: colors.red,
                          foregroundColor: colors.white,
                          child: SDeleteAssetIcon(
                            color: colors.white,
                          ),
                        ),
                      ],
                    )
                  : null,
              child: MyWalletsAssetItem(
                isMoving: widget.store.isReordering,
                currency: widget.store.currencies[index],
              ),
            ),
            if (widget.store.currencies[index].symbol == 'EUR')
              GetAccountButton(
                store: widget.store,
              ),
          ],
        ),
      );
    }

    return list;
  }

  Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    final colors = sKit.colors;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.white,
              boxShadow: [
                BoxShadow(
                  color: colors.grey1.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyWalletsAssetItem(
                  isMoving: true,
                  currency: widget.store.currencies[index],
                ),
                if (widget.store.currencies[index].symbol == 'EUR')
                  GetAccountButton(
                    store: widget.store,
                  ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}
