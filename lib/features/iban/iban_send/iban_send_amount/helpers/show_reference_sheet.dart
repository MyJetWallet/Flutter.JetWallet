import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:mobx/mobx.dart';

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
    isCharactersEnough = referenceTextField.text.length >= 5;
  }

  @observable
  bool isError = false;
  @action
  void setError(bool value) => isError = value;

  @action
  Future<void> paste() async {
    final copiedText = await _copiedText();
    referenceTextField.text = referenceTextField.text + copiedText.replaceAll(' ', '');

    _moveCursorAtTheEnd(referenceTextField);

    setCharactersEnough();
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}

void showReferenceSheet(BuildContext context, Function(String) onContinue) {
  sShowBasicModalBottomSheet(
    context: context,
    children: [
      _ReferenceBody(
        onContinue: onContinue,
      )
    ],
  );
}

class _ReferenceBody extends StatefulObserverWidget {
  const _ReferenceBody({
    Key? key,
    required this.onContinue,
  }) : super(key: key);
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
            style: sTextH4Style,
          ),
        ),
        const SpaceH20(),
        Observer(
          builder: (context) {
            return SPaddingH24(
              child: SStandardField(
                controller: store.referenceTextField,
                autofocus: true,
                isError: store.isError,
                labelText: intl.iban_reference,
                hideIconsIfNotEmpty: false,
                suffixIcons: [
                  SIconButton(
                    onTap: () {
                      store.paste().then((value) => setState(() {}));
                    },
                    defaultIcon: const SPasteIcon(),
                    pressedIcon: const SPastePressedIcon(),
                  ),
                ],
                onErase: () {},
                onChanged: (value) {
                  store.setError(false);

                  print(store.isCharactersEnough);

                  store.setCharactersEnough();
                },
              ),
            );
          },
        ),
        Material(
          color: sKit.colors.grey5,
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
                            style: sBodyText2Style.copyWith(
                              color: store.isCharactersEnough ? sKit.colors.blue : sKit.colors.black,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SpaceH32(),
                  SPrimaryButton2(
                    active: store.isCharactersEnough,
                    name: intl.withdraw_continue,
                    onTap: () {
                      if (store.referenceTextField.text.length >= 5) {
                        widget.onContinue(store.referenceTextField.text);

                        sRouter.pop();
                      } else {
                        store.setError(true);
                      }

                      return;
                    },
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
