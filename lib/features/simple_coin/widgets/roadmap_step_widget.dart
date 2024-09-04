import 'package:flutter/material.dart';
import 'package:jetwallet/features/simple_coin/models/road_map_steep_model.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class RoadmapStepWidget extends StatelessWidget {
  const RoadmapStepWidget({required this.event});
  final RoadmapStepModel event;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    const purple = Color(0xFF9B79FF);
    return SizedBox(
      height: event.isCompleted ? 40 : 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 10,
                color: event.isPreviosCompleted
                    ? purple
                    : event.isFirst
                        ? Colors.transparent
                        : event.isCompleted
                            ? purple
                            : colors.gray4,
              ),
              if (event.isCompleted)
                Assets.svg.small.checkCircle.simpleSvg(width: 20, height: 20, color: purple)
              else
                Assets.svg.small.minusCircle.simpleSvg(width: 20, height: 20, color: colors.gray8),
              if (!event.isLast)
                Container(
                  width: 2,
                  height: event.isCompleted ? 10 : 30,
                  color: event.isCompleted ? purple : colors.gray4,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: STStyles.body1Semibold.copyWith(
                      color: event.isCompleted ? purple : colors.black,
                    ),
                  ),
                  if (event.schedule != null && !event.isCompleted)
                    Text(
                      event.schedule ?? '',
                      style: STStyles.body2Medium.copyWith(
                        color: colors.gray8,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
