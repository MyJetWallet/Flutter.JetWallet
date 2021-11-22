import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:simple_kit/simple_kit.dart';

class CustomInternationalPhoneNumberInput extends StatelessWidget {
  const CustomInternationalPhoneNumberInput({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onValidated,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(PhoneNumber number) onChanged;
  final Function(bool value) onValidated;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InternationalPhoneNumberInput(
          textFieldController: controller,
          textStyle: sSubtitle1Style,
          textAlignVertical: TextAlignVertical.top,
          ignoreBlank: true,
          cursorColor: SColorsLight().blue,
          inputDecoration: InputDecoration(
            suffixIcon: controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.clear(),
                    child: const SEraseIcon(),
                  )
                : const SizedBox(),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 24.r,
              maxHeight: 24.r,
              minWidth: 24.r,
              minHeight: 24.r,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 24.h,
            ),
            labelText: 'Phone number',
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: SColorsLight().grey2,
              textBaseline: TextBaseline.alphabetic,
            ),
            border: InputBorder.none,
          ),
          autoFocusSearch: true,
          inputBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          searchBoxDecoration: InputDecoration(
            hintStyle: sTextH5Style,
            labelText: 'Search country',
            counterStyle: TextStyle(
              height: 12.h,
            ),
            floatingLabelStyle: TextStyle(
              color: SColorsLight().grey2,
              textBaseline: TextBaseline.alphabetic,
            ),
            contentPadding: EdgeInsets.zero,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
            ),
            alignLabelWithHint: true,
          ),
          selectorConfig: SelectorConfig(
            showFlags: false,
            leadingPadding: 3.h,
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),

          selectorTextStyle: sSubtitle2Style.copyWith(height: 3.h),
          onInputChanged: (number) => onChanged(number),
          onInputValidated: (valid) => onValidated(valid),
        ),

        Positioned(
          left: 74.w,
          child: Container(
            height: 88.h,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1.w,
                  color: SColorsLight().grey4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
