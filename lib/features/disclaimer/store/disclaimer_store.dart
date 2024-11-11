// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/disclaimer/helpers/disclaimer_questions_parser.dart';
import 'package:jetwallet/features/disclaimer/ui/disclaimer.dart';
import 'package:jetwallet/features/disclaimer/ui/widgets/disclaimer_checkbox.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_response_model.dart';

// ignore_for_file: avoid-wrapping-in-padding

part 'disclaimer_store.g.dart';

@lazySingleton
class DisclaimerStore = _DisclaimerStoreBase with _$DisclaimerStore;

abstract class _DisclaimerStoreBase with Store {
  // _DisclaimerStoreBase() {
  //   _init();
  // }

  static final _logger = Logger('DisclaimerStore');

  @observable
  bool disclaimerShowed = false;

  @observable
  String? imageUrl;

  @observable
  ObservableList<DisclaimerModel> disclaimers = ObservableList.of([]);

  @observable
  bool activeButton = false;

  @observable
  String disclaimerId = '';

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  ObservableList<DisclaimerQuestionsModel> questions = ObservableList.of([]);

  @action
  Future<void> init() async {
    _logger.log(notifier, 'init DisclaimerNotifier');

    try {
      final response = await sNetwork.getWalletModule().getDisclaimers();

      response.pick(
        onData: (data) {
          if (data.disclaimers != null) {
            final tempDisclaimers = ObservableList<DisclaimerModel>.of([]);
            for (final element in data.disclaimers!) {
              tempDisclaimers.add(
                DisclaimerModel(
                  description: element.description,
                  title: element.title,
                  disclaimerId: element.disclaimerId,
                  questions: element.questions,
                  imageUrl: element.imageUrl,
                ),
              );
            }

            disclaimers = ObservableList.of([...tempDisclaimers]);
            disclaimerId = tempDisclaimers[0].disclaimerId;
            description = tempDisclaimers[0].description;
            title = disclaimers[0].title;
            imageUrl = tempDisclaimers[0].imageUrl;
            questions = ObservableList.of(tempDisclaimers[0].questions);
            activeButton = _checkActiveButtonStatus(
              tempDisclaimers[0].questions,
            );
          }

          if (disclaimers.isNotEmpty) {
            Timer(
              Duration.zero,
              () {
                _displayDisclaimers(
                  disclaimerIndex: 0,
                  onAgree: () {},
                );
              },
            );
          }
        },
        onError: (e) {
          _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  @action
  Future<void> initNftDisclaimers(
    Function() onAgree,
  ) async {
    _logger.log(notifier, 'init initNftDisclaimers');

    try {
      final response = await sNetwork.getWalletModule().getNftDisclaimers();

      response.pick(
        onData: (data) {
          if (data.disclaimers != null) {
            final tempDisclaimers = ObservableList<DisclaimerModel>.of([]);
            for (final element in data.disclaimers!) {
              tempDisclaimers.add(
                DisclaimerModel(
                  description: element.description,
                  title: element.title,
                  disclaimerId: element.disclaimerId,
                  questions: element.questions,
                  imageUrl: element.imageUrl,
                ),
              );
            }

            disclaimers = ObservableList.of([...tempDisclaimers]);
            disclaimerId = tempDisclaimers[0].disclaimerId;
            description = tempDisclaimers[0].description;
            title = disclaimers[0].title;
            imageUrl = tempDisclaimers[0].imageUrl;
            questions = ObservableList.of(tempDisclaimers[0].questions);
            activeButton = _checkActiveButtonStatus(tempDisclaimers[0].questions);
          }

          if (disclaimers.isNotEmpty) {
            Timer(
              Duration.zero,
              () {
                _displayDisclaimers(
                  disclaimerIndex: 0,
                  onAgree: onAgree,
                );
              },
            );
          }
        },
        onError: (e) {
          _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'Failed to fetch disclaimers', e);
    }
  }

  @action
  void _displayDisclaimers({
    required int disclaimerIndex,
    required Function() onAgree,
  }) {
    if (disclaimerShowed) return;

    final context = sRouter.navigatorKey.currentContext!;
    final colors = sKit.colors;

    disclaimerShowed = true;

    showsDisclaimer(
      context: context,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          Future.value(false);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Dialog(
              insetPadding: const EdgeInsets.all(24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SpaceH40(),
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: imageUrl != null
                                        ? Image.network(
                                            imageUrl!,
                                          )
                                        : Image.asset(
                                            disclaimerAsset,
                                          ),
                                  ),
                                  Baseline(
                                    baseline: 40.0,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      title,
                                      maxLines: (description.isNotEmpty) ? 5 : 12,
                                      textAlign: TextAlign.center,
                                      style: STStyles.header6.copyWith(
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  const SpaceH7(),
                                  if (description.isNotEmpty)
                                    Text(
                                      description,
                                      maxLines: 6,
                                      textAlign: TextAlign.center,
                                      style: STStyles.body1Medium.copyWith(
                                        color: colors.grey1,
                                      ),
                                    ),
                                  const SpaceH35(),
                                  const SDivider(),
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          const SpaceH18(),
                                          for (final question in questions) ...[
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
                                            if (question != questions.last) const SpaceH18() else const SpaceH94(),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SFloatingButtonFrame2(
                            button: SButton.black(
                              text: intl.disclaimer_continue,
                              callback: activeButton
                                  ? () async {
                                      await _sendAnswers(
                                        context,
                                        disclaimerIndex,
                                        onAgree,
                                      );
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @action
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
            style: STStyles.captionMedium.copyWith(
              color: colors.blue,
            ),
          ),
        );
      } else {
        widgets.add(
          TextSpan(
            text: key,
            style: STStyles.captionMedium.copyWith(
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

  @action
  Future<void> _sendAnswers(
    BuildContext context,
    int disclaimerIndex,
    Function() onAgree,
  ) async {
    Navigator.pop(context);
    _logger.log(notifier, '_sendAnswers');

    final answers = _prepareAnswers(questions);

    final model = DisclaimersRequestModel(
      disclaimerId: disclaimerId,
      answers: answers,
    );

    try {
      final _ = await sNetwork.getWalletModule().postSaveDisclaimer(model);

      if (disclaimerIndex + 1 <= disclaimers.length) {
        final index = disclaimerIndex + 1;

        _updateDisclaimer(index);

        disclaimerShowed = false;

        _displayDisclaimers(disclaimerIndex: index, onAgree: onAgree);
      } else {
        onAgree.call();
      }
    } catch (error) {
      _logger.log(stateFlow, '_sendAnswers', error);
    }
  }

  @action
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

  @action
  void _updateDisclaimer(int index) {
    activeButton = _checkActiveButtonStatus(disclaimers[index].questions);
    imageUrl = disclaimers[index].imageUrl;
    title = disclaimers[index].title;
    description = disclaimers[index].description;
    disclaimerId = disclaimers[index].disclaimerId;
    questions = ObservableList.of(disclaimers[index].questions);
  }

  @action
  int _findQuestionIndex(DisclaimerQuestionsModel question) {
    for (final element in questions) {
      if (element.questionId == question.questionId) {
        return questions.indexOf(element);
      }
    }

    return 0;
  }

  @action
  void _onCheckboxTap(int index, int disclaimerIndex) {
    final questionsNewList = List<DisclaimerQuestionsModel>.from(
      questions,
    );

    questionsNewList[index] = DisclaimerQuestionsModel(
      questionId: questionsNewList[index].questionId,
      defaultState: !questionsNewList[index].defaultState,
      text: questionsNewList[index].text,
      required: questionsNewList[index].required,
    );

    questions = ObservableList.of(questionsNewList);
    activeButton = _checkActiveButtonStatus(questionsNewList);
  }

  @action
  bool _checkActiveButtonStatus(List<DisclaimerQuestionsModel> questions) {
    for (final element in questions) {
      if (element.required && !element.defaultState) {
        return false;
      }
    }

    return true;
  }
}
