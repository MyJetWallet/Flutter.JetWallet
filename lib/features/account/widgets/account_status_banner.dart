import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountStatusBanner extends StatefulWidget {
  const AccountStatusBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.mainColor,
    required this.textColor,
  });

  final Widget icon;
  final String title;
  final Function() onTap;
  final Color mainColor;
  final Color textColor;

  @override
  State<AccountStatusBanner> createState() => _AccountStatusBannerState();
}

class _AccountStatusBannerState extends State<AccountStatusBanner> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: 56,
      decoration: BoxDecoration(
        color:
            highlighted ? widget.mainColor.withOpacity(0.8) : widget.mainColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onHighlightChanged: (value) {
          highlighted = value;
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Row(
            children: [
              widget.icon,
              const SpaceW10(),
              Text(
                widget.title,
                style: sSubtitle2Style.copyWith(
                  color: widget.textColor,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              SBlueRightArrowIcon(
                color: widget.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
