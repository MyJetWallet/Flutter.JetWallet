import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_request_model.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_response_model.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'high_yield_disclaimer_state.dart';

class HighYieldDisclaimerNotifier
    extends StateNotifier<HighYieldDisclaimerState> {
  HighYieldDisclaimerNotifier({
    required this.read,
  }) : super(
          const HighYieldDisclaimerState(),
        ) {
    _init();
  }

  final Reader read;

  static final _logger = Logger('HighYieldDisclaimerNotifier');

  Future<void> _init() async {
    _logger.log(notifier, 'init HighYieldDisclaimerNotifier');

    final intl = read(intlPod);

    try {
      final response = await read(disclaimerServicePod)
              .highYieldDisclaimers(intl.localeName);

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

        state = state.copyWith(
          disclaimers: [...disclaimers],
          disclaimerId: disclaimers[0].disclaimerId,
          description: disclaimers[0].description,
          title: disclaimers[0].title,
          imageUrl: disclaimers[0].imageUrl,
          questions: disclaimers[0].questions,
          activeButton: false,
        );
      } else {
        state = state.copyWith(
          send: true,
        );
      }
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  Future<void> sendAnswers(Function() afterRequest) async {
    if (!state.activeButton) {
      return;
    }
    _logger.log(notifier, '_sendAnswers');

    final answers = _prepareAnswers(state.questions);

    final model = DisclaimersRequestModel(
      disclaimerId: state.disclaimerId,
      answers: answers,
    );

    try {
      final intl = read(intlPod);
      await read(disclaimerServicePod).saveDisclaimer(model, intl.localeName);
      state = state.copyWith(
        send: true,
      );
      afterRequest();

    } catch (error) {
      _logger.log(stateFlow, '_sendAnswers', error);
    }
  }

  List<DisclaimerAnswersModel> _prepareAnswers(
    List<DisclaimerQuestionsModel> questions,
  ) {
    final answers = <DisclaimerAnswersModel>[];

    for (final element in questions) {
      answers.add(
        DisclaimerAnswersModel(
          clientId: '',
          disclaimerId: '',
          questionId: element.questionId,
          result: true,
        ),
      );
    }

    return answers;
  }

  bool isCheckBoxActive() {
    return state.activeButton;
  }

  void onCheckboxTap() {
    state = state.copyWith(
      activeButton: !state.activeButton,
    );
  }
}
