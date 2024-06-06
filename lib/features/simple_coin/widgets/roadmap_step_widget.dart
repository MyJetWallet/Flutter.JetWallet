import 'package:flutter/widgets.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class RoadmapStepModel {
  RoadmapStepModel({
    required this.title,
    required this.isCompleted,
    this.schedule,
    this.isFirst = false,
    this.isLast = false,
    this.isPreviosCompleted = false,
  });
  final String title;
  final bool isCompleted;
  final String? schedule;
  final bool isFirst;
  final bool isLast;
  final bool isPreviosCompleted;
}

class RoadmapStepWidget extends StatelessWidget {
  const RoadmapStepWidget({required this.event});
  final RoadmapStepModel event;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: event.isCompleted ? 40 : 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 12,
                color: event.isPreviosCompleted
                    ? colors.greenLight
                    : event.isFirst
                        ? colors.white
                        : event.isCompleted
                            ? colors.greenLight
                            : colors.gray4,
              ),
              if (event.isCompleted)
                Assets.svg.small.checkCircle.simpleSvg(width: 20, height: 20, color: colors.green)
              else
                Assets.svg.small.minusCircle.simpleSvg(width: 20, height: 20, color: colors.gray8),
              if (!event.isLast)
                Container(
                  width: 2,
                  height: event.isCompleted ? 8 : 28,
                  color: event.isCompleted ? colors.greenLight : colors.gray4,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: STStyles.body1Semibold.copyWith(
                    color: event.isCompleted ? colors.green : colors.black,
                  ),
                ),
                if (event.schedule != null)
                  Text(
                    event.schedule ?? '',
                    style: STStyles.body2Medium.copyWith(
                      color: colors.gray8,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
