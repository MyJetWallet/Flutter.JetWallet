import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/disclaimer/model/disclaimers_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../model/disclaimer_model.dart';
import '../view/components/disclaimer_checkbox.dart';
import '../view/disclaimer.dart';
import 'disclaimer_notipod.dart';
import 'disclaimer_state.dart';

class DisclaimerNotifier extends StateNotifier<DisclaimerState> {
  DisclaimerNotifier({
    required this.read,
  }) : super(
          const DisclaimerState(
            disclaimers: <DisclaimerModel>[],
            disclaimerId: '',
            title: '',
            description: '',
            questions: <DisclaimerQuestionsModel>[],
          ),
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

        state = state.copyWith(
          disclaimers: [...disclaimers],
          disclaimerId: disclaimers[0].disclaimerId,
          description: disclaimers[0].description,
          title: disclaimers[0].title,
          imageUrl: disclaimers[0].imageUrl,
          questions: disclaimers[0].questions,
          activeButton: _checkActiveButtonStatus(disclaimers[0].questions),
        );
      }

      if (state.disclaimers != null) {
        if (state.disclaimers!.isNotEmpty) {
          Timer(Duration.zero, () {
            _displayDisclaimers(
              disclaimerIndex: 0,
            );
          });
        }
      }
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  void _displayDisclaimers({
    required int disclaimerIndex,
  }) {
    final context = read(sNavigatorKeyPod).currentContext!;

    showsDisclaimer(
      context: context,
      imageAsset: state.imageUrl,
      primaryText: state.title,
      secondaryText: state.description,
      questions: state.questions,
      primaryButtonName: 'Continue',
      activePrimaryButton: state.activeButton,
      child: StatefulBuilder(
        builder: (context, setState) {
          final state = context.read(disclaimerNotipod);

          return Column(
            children: [
              for (final question in state.questions) ...[
                DisclaimerCheckbox(
                  firstText: question.text,
                  indexCheckBox: _findQuestionIndex(question),
                  onCheckboxTap: () => setState(() {
                    _onCheckboxTap(
                      _findQuestionIndex(question),
                      disclaimerIndex,
                    );
                  }),
                ),
              ],
              SPrimaryButton1(
                name: 'Continue',
                active: state.activeButton,
                onTap: () async {
                  await _sendAnswers(context, disclaimerIndex);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sendAnswers(BuildContext context, int disclaimerIndex) async {
    _logger.log(notifier, '_sendAnswers');

    final answers = _prepareAnswers(state.questions);

    final model = DisclaimersRequestModel(
      disclaimerId: state.disclaimerId,
      answers: answers,
    );

    try {
      await read(disclaimerServicePod).saveDisclaimer(model);

      if (disclaimerIndex <= state.disclaimers!.length) {
        if (!mounted) return;

        Navigator.pop(context);

        final index = disclaimerIndex + 1;

        _updateDisclaimer(index);

        _displayDisclaimers(disclaimerIndex: index);
      }
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
          result: element.defaultState,
        ),
      );
    }

    return answers;
  }

  void _updateDisclaimer(int index) {
    state = state.copyWith(
      activeButton:
          _checkActiveButtonStatus(state.disclaimers![index].questions),
      imageUrl: state.disclaimers![index].imageUrl,
      title: state.disclaimers![index].title,
      description: state.disclaimers![index].description,
      disclaimerId: state.disclaimers![index].disclaimerId,
      questions: state.disclaimers![index].questions,
    );
  }

  int _findQuestionIndex(DisclaimerQuestionsModel question) {
    for (final element in state.questions) {
      if (element.questionId == question.questionId) {
        return state.questions.indexOf(element);
      }
    }
    return 0;
  }

  void _onCheckboxTap(int index, int disclaimerIndex) {
    final questionsNewList = List<DisclaimerQuestionsModel>.from(
      state.questions,
    );

    questionsNewList[index] = DisclaimerQuestionsModel(
      questionId: questionsNewList[index].questionId,
      defaultState: !questionsNewList[index].defaultState,
      text: questionsNewList[index].text,
      required: questionsNewList[index].required,
    );

    state = state.copyWith(
      questions: questionsNewList,
      activeButton: _checkActiveButtonStatus(questionsNewList),
    );
  }

  bool _checkActiveButtonStatus(List<DisclaimerQuestionsModel> questions) {
    for (final element in questions) {
      if (element.required && !element.defaultState) {
        return false;
      }
    }
    return true;
  }
}
