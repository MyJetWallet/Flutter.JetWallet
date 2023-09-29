import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
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
import 'package:visibility_detector/visibility_detector.dart';

class AssetsListWidget extends StatefulObserverWidget {
  const AssetsListWidget({
    super.key,
  });

  @override
  State<AssetsListWidget> createState() => _AssetsListWidgetState();
}

class _AssetsListWidgetState extends State<AssetsListWidget> {
  final store = getIt.get<MyWalletsSrore>();

  @override
  Widget build(BuildContext context) {
    final list = slidableItems();

    return VisibilityDetector(
      key: const Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 0) {
          store.isReordering = false;
        }
      },
      child: Column(
        children: [
          if (store.isReordering)
            ChangeOrderWidget(
              onPressedDone: store.onEndReordering,
            ),
          SlidableAutoCloseBehavior(
            child: ReorderableListView(
              proxyDecorator: _proxyDecorator,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: store.isReordering,
              onReorder: (int oldIndex, int newIndex) {
                store.onReorder(oldIndex, newIndex);
                setState(() {});
              },
              children: list,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> slidableItems() {
    final colors = sKit.colors;
    final list = <Widget>[];

    for (var index = 0; index < store.currencies.length; index += 1) {
      list.add(
        Column(
          key: ValueKey(store.currencies[index].symbol),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slidable(
              startActionPane: !store.isReordering
                  ? ActionPane(
                      extentRatio: 0.2,
                      motion: const StretchMotion(),
                      children: [
                        Builder(
                          builder: (context) {
                            return CustomSlidableAction(
                              onPressed: (context) {
                                store.onStartReordering();
                              },
                              backgroundColor: colors.purple,
                              foregroundColor: colors.white,
                              child: SStartReorderIcon(
                                color: colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              endActionPane: store.currencies[index].isAssetBalanceEmpty
                  ? ActionPane(
                      extentRatio: 0.2,
                      motion: const StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            store.onDelete(index);
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
                isMoving: store.isReordering,
                currency: store.currencies[index],
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
            child: MyWalletsAssetItem(
              isMoving: true,
              currency: store.currencies[index],
            ),
          ),
        );
      },
      child: child,
    );
  }
}
