import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/simple_coin/widgets/roadmap_step_widget.dart';

class SimpleCoinRoadmap extends StatelessWidget {
  SimpleCoinRoadmap({super.key});

  final List<RoadmapStepModel> events = [
    RoadmapStepModel(
      title: intl.simplecoin_launch_game,
      isCompleted: true,
      isFirst: true,
    ),
    RoadmapStepModel(
      title: intl.simplecoin_boost_tasks,
      isCompleted: true,
    ),
    RoadmapStepModel(
      title: intl.simplecoin_collect_coins,
      isCompleted: false,
      schedule: intl.simplecoin_scheduled_for_q2_2024,
      isPreviosCompleted: true,
    ),
    RoadmapStepModel(
      title: intl.simplecoin_token_smpl,
      isCompleted: false,
      schedule: intl.simplecoin_scheduled_for_q3_q4_2024,
    ),
    RoadmapStepModel(
      title: intl.simplecoin_partner_engagement,
      isCompleted: false,
      schedule: intl.simplecoin_scheduled_for_q4_2024,
    ),
    RoadmapStepModel(
      title: intl.simplecoin_listing,
      isCompleted: false,
      schedule: intl.simplecoin_scheduled_for_q1_2025,
      isLast: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return RoadmapStepWidget(event: events[index]);
      },
    );
  }
}
