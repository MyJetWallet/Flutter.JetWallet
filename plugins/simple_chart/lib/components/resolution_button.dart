import 'package:flutter/material.dart';

class ResolutionButton extends StatelessWidget {
  const ResolutionButton({
    super.key,
    required this.text,
    required this.showUnderline,
    required this.onTap,
  });

  final String text;
  final bool showUnderline;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*const SizedBox(
          height: 10,
        ),
        */
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            width: 44,
            height: 27,
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 1.5,
        ),
        if (showUnderline)
          Container(
            width: 44,
            height: 3,
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.black,
            ),
          )
        else
          const SizedBox(
            height: 8,
          ),
      ],
    );
  }
}
