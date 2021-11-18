import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../constants.dart';
import '../../two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../two_fa_phone/view/two_fa_phone.dart';

void showSmsAuthWarning(BuildContext context) {
  showDialog(
    context: context,
    builder: (builderContext) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(24.r),
              ),
            ),
            buttonPadding: EdgeInsets.symmetric(horizontal: 20.w),
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 40.h,
                  ),
                  height: 80.h,
                  child: Image.asset(ellipsisAsset),
                ),
              ],
            ),
            content: Column(
              children: [
                Baseline(
                  baseline: 40.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Are you sure you want to',
                        style: sTextH5Style,
                      ),
                      Text(
                        'disable SMS Authentication?',
                        style: sTextH5Style,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Baseline(
                    baseline: 32.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I understand and accept all risks ',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        Text(
                          'associated with lowering the level of',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        Text(
                          'account security. For security reasons,',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        Text(
                          'the ability to withdraw funds from the',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        Text(
                          'account will be suspended for 24',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                        Text(
                          'hours.',
                          style: TextStyle(
                            color: SColorsLight().grey1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Column(
                children: [
                  SPrimaryButton1(
                    name: 'Continue',
                    active: true,
                    onTap: () {
                      TwoFaPhone.pushReplacement(
                        builderContext,
                        const Security(
                          fromDialog: true,
                        ),
                      );
                    },
                  ),
                  const SpaceH10(),
                  STextButton1(
                    name: 'Later',
                    active: true,
                    onTap: (){
                      Navigator.pop(builderContext);
                    },
                  ),
                  const SpaceH20(),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
