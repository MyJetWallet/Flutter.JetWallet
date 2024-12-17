import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';

@RoutePage(name: 'DebugHistoryRouter')
class DebugHistory extends StatefulWidget {
  const DebugHistory({super.key});

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
            source: TransactionItemSource.history,
          ),
        ],
      ),
    );
  }
}
