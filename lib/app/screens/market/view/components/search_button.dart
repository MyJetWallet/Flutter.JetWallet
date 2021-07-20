import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/market_stpod.dart';

class SearchButton extends HookWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(marketStpod);

    return Ink(
      decoration: ShapeDecoration(
        color: Colors.grey.shade100,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(Icons.search),
        color: Colors.grey.shade600,
        onPressed: () {
          state.state = MarketState.search;
        },
      ),
    );
  }
}
