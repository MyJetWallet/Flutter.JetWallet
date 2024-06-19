import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/simple_coin/models/road_map_steep_model.dart';
import 'package:jetwallet/features/simple_coin/widgets/roadmap_step_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SimpleCoinRoadmap extends StatefulWidget {
  const SimpleCoinRoadmap({super.key});

  @override
  State<SimpleCoinRoadmap> createState() => _SimpleCoinRoadmapState();
}

class _SimpleCoinRoadmapState extends State<SimpleCoinRoadmap> {
  @override
  void initState() {
    final completedIndex = simpleCoinRoadmapCompletedSteep - 1;
    final proscessedList = setCompletedSteeps(completedIndex);

    setState(() {
      events = proscessedList;
    });

    super.initState();
  }

  List<RoadmapStepModel> events = [
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

  List<RoadmapStepModel> setCompletedSteeps(int completedIndex) {
    final tempList = <RoadmapStepModel>[];
    for (var i = 0; i < events.length; i++) {
      var steep = events[i];
      steep = steep.copyWith(
        isCompleted: i <= completedIndex,
        isPreviosCompleted: i > 0 && i - 1 <= completedIndex,
      );
      tempList.add(steep);
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: ShapeDecoration(
          color: colors.gray2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: events.length,
          itemBuilder: (context, index) {
            return RoadmapStepWidget(event: events[index]);
          },
        ),
      ),
    );
  }
}
