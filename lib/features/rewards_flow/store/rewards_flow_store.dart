import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
part 'rewards_flow_store.g.dart';

class RewardsFlowStore extends _RewardsFlowStoreBase with _$RewardsFlowStore {
  RewardsFlowStore() : super();

  static RewardsFlowStore of(BuildContext context) =>
      Provider.of<RewardsFlowStore>(context, listen: false);
}

abstract class _RewardsFlowStoreBase with Store {}
