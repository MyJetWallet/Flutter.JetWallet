import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SCommandBar extends StatelessWidget {
  const SCommandBar({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  final String title;
  final String description;
  final String buttonText;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Color(0xFFE0E4EA)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .5,
                        maxHeight: 24,
                      ),
                      child: Text(
                        title,
                        style: STStyles.body1Semibold.copyWith(
                          color: SColorsLight().black,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .5,
                        maxHeight: 24,
                      ),
                      child: Text(
                        description,
                        style: STStyles.body2Medium.copyWith(
                          color: SColorsLight().gray8,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SButtonContext(
                  type: SButtonContextType.iconedSmall,
                  icon: Assets.svg.medium.checkmark,
                  onTap: onTap,
                  text: buttonText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
