import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/get_account_button.dart';
import 'package:jetwallet/features/my_wallets/widgets/my_wallets_asset_item.dart';
import 'package:simple_kit/modules/icons/24x24/public/delete_asset/simple_delete_asset.dart';
import 'package:simple_kit/modules/icons/24x24/public/start_reorder/simple_start_reorder_icon.dart';
import 'package:simple_kit/simple_kit.dart';
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
          RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              _OnlyOnePointerRecognizer: GestureRecognizerFactoryWithHandlers<_OnlyOnePointerRecognizer>(
                () => _OnlyOnePointerRecognizer(),
                (_OnlyOnePointerRecognizer instance) {},
              ),
            },
            child: SlidableAutoCloseBehavior(
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
            if (!store.isReordering && store.currencies[index].symbol == 'EUR')
              GetAccountButton(
                store: store,
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

class _OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}
