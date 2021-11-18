import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class PhoneNumberSearch extends StatelessWidget {
  const PhoneNumberSearch({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  final Function(String value) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SStandardField(
          labelText: 'Search country',
          autofocus: true,
          autofillHints: const [AutofillHints.telephoneNumber],
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          alignLabelWithHint: true,
          onChanged: (String value) => onChange(value),
        ),
      ],
    );
  }
}
