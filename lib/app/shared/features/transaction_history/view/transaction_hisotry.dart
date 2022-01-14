import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jetwallet/shared/helpers/navigator_push.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionHistory extends HookWidget {
  const TransactionHistory({
    Key? key,
    required this.assetId,
    required this.assetName,
  }) : super(key: key);

  final String assetId;
  final String assetName;

  static void push({
    required BuildContext context,
    required String assetId,
    required String assetName,
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
    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: 'History $assetName ($assetId)',
      ),
      child: Container(),
    );
  }
}
