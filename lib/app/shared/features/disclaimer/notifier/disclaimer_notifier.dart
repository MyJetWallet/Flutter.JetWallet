import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../model/disclaimer_model.dart';
import 'disclaimer_state.dart';

class DisclaimerNotifier extends StateNotifier<DisclaimerState> {
  DisclaimerNotifier({
    required this.read,
  }) : super(
          const DisclaimerState(disclaimers: <DisclaimerModel>[]),
        ) {
    _init();
  }

  final Reader read;

  static final _logger = Logger('DisclaimerNotifier');

  Future<void> _init() async {
    _logger.log(notifier, 'init DisclaimerNotifier');

    try {
      final response = await read(disclaimerServicePod).disclaimers();

      if (response.disclaimers != null) {
        final disclaimers = <DisclaimerModel>[];
        for (final element in response.disclaimers!) {
          disclaimers.add(
            DisclaimerModel(
              description: element.description,
              title: element.title,
              disclaimerId: element.disclaimerId,
              questions: element.questions,
              imageUrl: element.imageUrl,
            ),
          );
        }
        state = state.copyWith(disclaimers: [...disclaimers]);
      }

      print('||||||| $state');
    } catch (e) {

    }
  }
}
