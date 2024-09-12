import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'my_wallets_scroll_store.g.dart';

@singleton
class MyWalletsScrollStore extends _MyWalletsScrollStoreBase with _$MyWalletsScrollStore {
  MyWalletsScrollStore() : super();

  static _MyWalletsScrollStoreBase of(BuildContext context) => Provider.of<MyWalletsScrollStore>(context);
}

abstract class _MyWalletsScrollStoreBase with Store {
  @observable
  ScrollController controller = ScrollController();

  void init() {
    controller.addListener(() {
      if (controller.position.pixels <= 0) {
        if (!isTopPosition) {
          setIsTopPosition(true);
        }
      } else {
        if (isTopPosition) {
          setIsTopPosition(false);
        }
      }
    });
  }

  @observable
  GlobalKey jarTitleKey = GlobalKey();

  @observable
  bool isTopPosition = true;

  @action
  void setIsTopPosition(bool value) => isTopPosition = value;

  @action
  void scrollToJarTitle() {
    void scroll() {
      final renderBox = jarTitleKey.currentContext!.findRenderObject()! as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero).dy;

      final scrollOffset = offset + controller.offset - 120;

      controller.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }

    if (isTopPosition) {
      controller.animateTo(
        10,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(milliseconds: 450)).then((_) {
        scroll();
      });
    } else {
      scroll();
    }
  }
}
