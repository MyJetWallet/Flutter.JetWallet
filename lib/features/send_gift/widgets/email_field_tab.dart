import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/fields/standard_field/public/simple_standard_field.dart';
import 'package:simple_kit/modules/icons/24x24/public/paste/simple_paste_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/paste/simple_paste_pressed_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';

import '../../../core/l10n/i10n.dart';
import '../store/receiver_datails_store.dart';

class EmailFieldTab extends StatefulWidget {
  const EmailFieldTab({super.key, required this.store});

  final ReceiverDatailsStore store;

  @override
  State<EmailFieldTab> createState() => _EmailFieldTabState();
}

class _EmailFieldTabState extends State<EmailFieldTab> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.store.email);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SPaddingH24(
          child: SStandardField(
            labelText: intl.send_gift_e_mail_address,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            controller: _textController,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('[ ]'),
              ),
            ],
            onChanged: (text) {
              widget.store.onChangedEmail(text);
            },
            onErase: () {
              widget.store.onChangedEmail('');
              _textController = TextEditingController(text: '');
            },
            isError: widget.store.showEmailError,
            suffixIcons: [
              SIconButton(
                onTap: () async {
                  final data = await Clipboard.getData('text/plain');
                  final text = data?.text?.replaceAll(' ', '');
                  if (text != null) {
                    widget.store.onChangedEmail(text);
                  }
                  _textController = TextEditingController(text: text);
                  _textController.selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: _textController.text.length,
                    ),
                  );
                },
                defaultIcon: const SPasteIcon(),
                pressedIcon: const SPastePressedIcon(),
              ),
            ],
            maxLines: 1,
            hideSpace: true,
          ),
        );
      },
    );
  }
}
