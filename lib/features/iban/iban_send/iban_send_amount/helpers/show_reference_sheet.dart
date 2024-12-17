import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';

part 'show_reference_sheet.g.dart';

class _ReferenceStore = __ReferenceStoreBase with _$_ReferenceStore;

abstract class __ReferenceStoreBase with Store {
  final referenceTextField = TextEditingController(
    text: 'Sent from Simple',
  );

  @observable
  bool isCharactersEnough = true;
  @action
  void setCharactersEnough() {
    isCharactersEnough = referenceTextField.text.length >= 5 && referenceTextField.text.length <= 100;
  }

  @observable
  bool isError = false;
  @action
  void setError(bool value) => isError = value;

  @action
  Future<void> paste() async {
    final copiedText = await _copiedText();
    referenceTextField.text = referenceTextField.text + copiedText;

    _moveCursorAtTheEnd(referenceTextField);

    setCharactersEnough();
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return data?.text ?? '';
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}

void showReferenceSheet(BuildContext context, Function(String) onContinue) {
  showBasicBottomSheet(
    context: context,
    children: [
      _ReferenceBody(
        onContinue: onContinue,
      ),
    ],
  );
}

class _ReferenceBody extends StatefulObserverWidget {
  const _ReferenceBody({
    required this.onContinue,
  });
  final Function(String) onContinue;

  @override
  State<_ReferenceBody> createState() => _ReferenceBodyState();
}

class _ReferenceBodyState extends State<_ReferenceBody> {
  final store = _ReferenceStore();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPaddingH24(
          child: Text(
            intl.iban_reference,
            style: STStyles.header5,
          ),
        ),
        const SpaceH20(),
        Observer(
          builder: (context) {
            return SInput(
              controller: store.referenceTextField,
              autofocus: true,
              hasErrorIcon: store.isError,
              label: intl.iban_reference,
              maxLength: 100,
              suffixIcon: SafeGesture(
                onTap: () {
                  store.paste().then((value) => setState(() {}));
                },
                child: const SPasteIcon(),
              ),
              onChanged: (value) {
                store.setError(false);

                store.setCharactersEnough();
              },
            );
          },
        ),
        Material(
          color: SColorsLight().gray2,
          child: SPaddingH24(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SpaceH16(),
                  Observer(
                    builder: (context) {
                      return Row(
                        children: [
                          if (!store.isCharactersEnough) const SMinusListIcon() else const SCheckListIcon(),
                          const SpaceW12(),
                          Text(
                            intl.reference_character_minimum,
                            style: STStyles.body2Medium.copyWith(
                              color: store.isCharactersEnough ? SColorsLight().blue : SColorsLight().black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SpaceH32(),
                  SButton.blue(
                    text: intl.withdraw_continue,
                    callback: store.isCharactersEnough
                        ? () {
                            if (store.referenceTextField.text.length >= 5) {
                              widget.onContinue(store.referenceTextField.text);

                              sRouter.maybePop();
                            } else {
                              store.setError(true);
                            }

                            return;
                          }
                        : null,
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
