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
  bool isError = false;
  @action
  void setError(bool value) => isError = value;

  @action
  Future<void> paste() async {
    final copiedText = await _copiedText();
    referenceTextField.text = copiedText.replaceAll(' ', '');

    _moveCursorAtTheEnd(referenceTextField);
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
  final store = _ReferenceStore();

  sShowBasicModalBottomSheet(
    context: context,
    children: [
      _ReferenceBody(
        store: store,
        onContinue: onContinue,
      )
    ],
  );
}

class _ReferenceBody extends StatelessObserverWidget {
  const _ReferenceBody({
    Key? key,
    required this.store,
    required this.onContinue,
  }) : super(key: key);

  final _ReferenceStore store;
  final Function(String) onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                suffixIcons: [
                  SIconButton(
                    onTap: () {
                      store.paste();
                    },
                    defaultIcon: const SPasteIcon(),
                    pressedIcon: const SPastePressedIcon(),
                  ),
                ],
                onErase: () {},
                onChanged: (value) {
                  store.setError(false);
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
                  const SpaceH32(),
                  SPrimaryButton2(
                    active: true,
                    name: intl.withdraw_continue,
                    onTap: () {
                      if (store.referenceTextField.text.length > 5) {
                        onContinue(store.referenceTextField.text);

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
