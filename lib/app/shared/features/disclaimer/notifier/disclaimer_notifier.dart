import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/disclaimer/model/disclaimers_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../model/disclaimer_model.dart';
import '../view/disclaimer.dart';
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

          // disclaimers.add(
          //   DisclaimerModel(
          //     description: 'AAAA',
          //     title: 'BBBB',
          //     disclaimerId: element.disclaimerId,
          //     questions: element.questions,
          //     imageUrl: element.imageUrl,
          //   ),
          // );
        }
        state = state.copyWith(disclaimers: [...disclaimers]);
      }

      if (state.disclaimers != null) {
        if (state.disclaimers!.isNotEmpty) {
          _displayDisclaimers(
            disclaimerIndex: 0,
          );
        }
      }
    } catch (e) {}
  }

  void _displayDisclaimers({
    required int disclaimerIndex,
  }) {
    final context = read(sNavigatorKeyPod).currentContext!;

    showsDisclaimer(
      context: context,
      primaryText: state.disclaimers![disclaimerIndex].title,
      secondaryText: state.disclaimers![disclaimerIndex].description,
      questions: state.disclaimers![disclaimerIndex].questions,
      primaryButtonName: 'Continue',
      activePrimaryButton: _activeDisclaimerButton(disclaimerIndex),
      // activePrimaryButton: true,
      child: Column(
        children: [
          for (final question
              in state.disclaimers![disclaimerIndex].questions) ...[
            SDisclaimerCheckbox(
              firstText: question.text,
              isChecked: question.defaultState,
              onCheckboxTap: () => checkedQuestion(question, disclaimerIndex),
              onUserAgreementTap: () {},
              onPrivacyPolicyTap: () {},
            ),
          ],
        ],
      ),
      // child: _questions(
      //   questions: state.disclaimers![disclaimerIndex].questions,
      //   disclaimerIndex: disclaimerIndex,
      //
      // ),
      onPrimaryButtonTap: () async {
        final answers = <DisclaimerAnswersModel>[];

        for (final element in state.disclaimers![disclaimerIndex].questions) {
          answers.add(
            DisclaimerAnswersModel(
              questionId: element.questionId,
              value: element.defaultState,
            ),
          );
        }

        final model = DisclaimersRequestModel(
          disclaimerId: state.disclaimers![disclaimerIndex].disclaimerId,
          answers: answers,
        );

        await read(disclaimerServicePod).saveDisclaimer(model);

        if (disclaimerIndex <= state.disclaimers!.length) {
          if (!mounted) return;

          Navigator.pop(context);

          final index = disclaimerIndex + 1;
          _displayDisclaimers(disclaimerIndex: index);
        }
      },
    );
  }

  bool _activeDisclaimerButton(int disclaimerIndex) {
    for (final element in state.disclaimers![disclaimerIndex].questions) {
      if (element.required && !element.defaultState) {
        return false;
      }
    }

    return true;
  }

  // Column _questions({
  //   required List<DisclaimerQuestionsModel> questions,
  //   required int disclaimerIndex,
  // }) {
  //   return Column(
  //     children: [
  //       for (final question
  //           in state.disclaimers![disclaimerIndex].questions) ...[
  //         SDisclaimerCheckbox(
  //           firstText: question.text,
  //           isChecked: question.defaultState,
  //           onCheckboxTap: () => _checkedQuestion(question, disclaimerIndex),
  //           onUserAgreementTap: () {},
  //           onPrivacyPolicyTap: () {},
  //         ),
  //       ],
  //     ],
  //   );
  // }

  void checkedQuestion(
    DisclaimerQuestionsModel question,
    int disclaimerIndex,
  ) {
    print('CHECK TAp $disclaimerIndex');

    print('}}}STATE Before UPDATER{{{{ ${state}');

    final newList = List<DisclaimerModel>.from(state.disclaimers!);
    final questionsList = List<DisclaimerQuestionsModel>.from(state.disclaimers![disclaimerIndex].questions);

    print('|newList| $newList');

    // final element = newList[disclaimerIndex].questions
    //     .firstWhere((element) => element == question, orElse: () => null);

    final element = questionsList
        .firstWhere((element) => element.questionId == question.questionId);

    if (newList[disclaimerIndex].questions.contains(element)) {
      final index = questionsList.indexOf(question);

      // print('|||element|||| $element');

      // print('|||index|||| $index');
      //
      // print(
      //     '|||state|||| ${state.disclaimers![disclaimerIndex].questions[index]}');

      print('|questionsList[index]|||| ${questionsList[index]}');

      // questionsList[index].defaultState = !newList[disclaimerIndex].questions[index].defaultState;

      try {
        // print('||BOX VALUE| ${!newList[disclaimerIndex].questions[index].defaultState}');

        newList[disclaimerIndex].questions[index] = DisclaimerQuestionsModel(
          questionId: newList[disclaimerIndex].questions[index].questionId,
          text: newList[disclaimerIndex].questions[index].text,
          required: newList[disclaimerIndex].questions[index].required,
          defaultState: !newList[disclaimerIndex].questions[index].defaultState,
        );

        print('||BOX VALUE| ${newList}');

        state = state.copyWith(disclaimers: newList);

        print('}}}STATE AFTER UPDATER{{{{ ${state}');
        // state.disclaimers![disclaimerIndex].questions[index] =
        //     state.disclaimers![disclaimerIndex].questions[index].copyWith(
        //   defaultState:
        //       !state.disclaimers![disclaimerIndex].questions[index].defaultState,
        // );

        // state = state.copyWith(
        //   disclaimers: [
        //     const DisclaimerModel(
        //       description: 'element.description',
        //       title: 'element.title',
        //       disclaimerId: 'element.disclaimerId',
        //       questions: [
        //         DisclaimerQuestionsModel(
        //           questionId: 'f241fe942cb74536ac05ac1e5e57dd8a',
        //           text: 'Placeholder for test-test: ',
        //           required: false,
        //           defaultState: true,
        //         ),
        //       ],
        //       imageUrl: 'element.imageUrl',
        //     )
        //   ],
        // );

        // state.disclaimers![disclaimerIndex].questions[index].copyWith(defaultState: true);
        //     DisclaimerQuestionsModel(
        //   questionId:
        //       state.disclaimers![disclaimerIndex].questions[index].questionId,
        //   text: state.disclaimers![disclaimerIndex].questions[index].text,
        //   required: state.disclaimers![disclaimerIndex].questions[index].required,
        //   defaultState:
        //       !state.disclaimers![disclaimerIndex].questions[index].defaultState,
        // );

        print(
            '|||AFTER|||| ${state.disclaimers![disclaimerIndex].questions[index]}');

        print('|||AFTER11|||| $state');
      } catch (e) {
        print('|ERROR| $e');
      }
    }
  }
}
