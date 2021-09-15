import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../spacers.dart';
import 'components/frame_action_button.dart';
import 'components/page_frame_header.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({
    Key? key,
    this.header,
    this.onBackButton,
    this.leftIcon = Icons.arrow_back,
    this.resizeToAvoidBottomInset = true,
    required this.child,
  }) : super(key: key);

  final String? header;
  final Function()? onBackButton;
  final IconData leftIcon;
  final bool resizeToAvoidBottomInset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onBackButton != null)
                Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FrameActionButton(
                          icon: leftIcon,
                          onTap: onBackButton!,
                        ),
                      ),
                    ),
                    if (header != null)
                      Expanded(
                        child: Center(
                          child: PageFrameHeader(
                            text: header!,
                          ),
                        ),
                      ),
                    const SpaceW40(),
                  ],
                ),
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
