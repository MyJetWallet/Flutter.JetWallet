import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';

@RoutePage(name: 'DebugHistoryRouter')
class DebugHistory extends StatefulWidget {
  const DebugHistory({Key? key}) : super(key: key);

  @override
  State<DebugHistory> createState() => _DebugHistoryState();
}

class _DebugHistoryState extends State<DebugHistory> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          TransactionsList(
            scrollController: _scrollController,
            symbol: '_DEBUG_',
            onItemTapLisener: (symbol) {},
          ),
        ],
      ),
    );
  }
}
