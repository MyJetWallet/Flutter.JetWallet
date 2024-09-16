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
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            width: 62,
            height: 27,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: showUnderline
                ? BoxDecoration(
                    color: const Color(0x0A001B4B),
                    borderRadius: BorderRadius.circular(14),
                  )
                : null,
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
          height: 9.5,
        ),
      ],
    );
  }
}
