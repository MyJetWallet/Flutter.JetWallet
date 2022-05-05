import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_request_model.dart';
import 'package:simple_networking/services/disclaimer/model/disclaimers_response_model.dart';

import '../../../../../shared/helpers/launch_url.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helpers/disclaimer_questions_parser.dart';
import '../view/components/disclaimer_checkbox.dart';
import '../view/disclaimer.dart';
import 'disclaimer_notipod.dart';
import 'disclaimer_state.dart';

class DisclaimerNotifier extends StateNotifier<DisclaimerState> {
  DisclaimerNotifier({
    required this.read,
  }) : super(
          const DisclaimerState(),
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

      if (state.disclaimers.isNotEmpty) {
        Timer(Duration.zero, () {
          _displayDisclaimers(
            disclaimerIndex: 0,
          );
        });
      }
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  void _displayDisclaimers({
    required int disclaimerIndex,
  }) {
    final context = read(sNavigatorKeyPod).currentContext!;
    final colors = read(sColorPod);

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
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SpaceH20(),
                      for (final question in state.questions) ...[
                        DisclaimerCheckbox(
                          questions: parsedTextWidget(
                            question.text,
                            context,
                            colors,
                          ),
                          firstText: question.text,
                          indexCheckBox: _findQuestionIndex(question),
                          onCheckboxTap: () => setState(() {
                            _onCheckboxTap(
                              _findQuestionIndex(question),
                              disclaimerIndex,
                            );
                          }),
                        ),
                        const SpaceH10(),
                      ],
                    ],
                  ),
                ),
              ),
              const SpaceH20(),
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

  Flexible parsedTextWidget(
    String text,
    BuildContext context,
    SimpleColors colors,
  ) {
    final widgets = <TextSpan>[];

    disclaimerQuestionsParser(text).forEach((key, value) {
      if (value.isNotEmpty) {
        widgets.add(
          TextSpan(
            text: value,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchURL(
                  context,
                  key,
                );
              },
            style: sCaptionTextStyle.copyWith(
              color: colors.blue,
            ),
          ),
        );
      } else {
        widgets.add(
          TextSpan(
            text: key,
            style: sCaptionTextStyle.copyWith(
              color: Colors.black,
            ),
          ),
        );
      }
    });

    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(
          top: 2,
        ),
        child: RichText(
          text: TextSpan(
            children: widgets,
          ),
        ),
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

      if (disclaimerIndex <= state.disclaimers.length) {
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
          _checkActiveButtonStatus(state.disclaimers[index].questions),
      imageUrl: state.disclaimers[index].imageUrl,
      title: state.disclaimers[index].title,
      description: state.disclaimers[index].description,
      disclaimerId: state.disclaimers[index].disclaimerId,
      questions: state.disclaimers[index].questions,
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
