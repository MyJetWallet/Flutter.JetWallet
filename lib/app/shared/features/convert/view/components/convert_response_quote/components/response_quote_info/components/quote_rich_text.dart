import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuoteRichText extends StatelessWidget {
  const QuoteRichText({
    Key? key,
    required this.boldText,
    required this.plainText,
  }) : super(key: key);

  final String boldText;
  final String plainText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: boldText,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
        children: <TextSpan>[
          TextSpan(
            text: plainText,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
