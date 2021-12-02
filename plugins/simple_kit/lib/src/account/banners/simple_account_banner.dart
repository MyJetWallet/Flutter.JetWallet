import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../simple_kit.dart';

class SimpleAccountBanner extends StatelessWidget {
  const SimpleAccountBanner({
    Key? key,
    this.imageUrl,
    required this.header,
    required this.description,
    required this.bannerColor,
  }) : super(key: key);

  final String? imageUrl;
  final String header;
  final String description;
  final Color bannerColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 20.h,
            right: 10.w,
          ),
          width: 327.w,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.w,
            bottom: 30.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: bannerColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundImage:
                    (imageUrl != null) ? NetworkImage(imageUrl!) : null,
              ),
              const SpaceW16(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Baseline(
                    baseline: 20.h,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      header,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: sTextH5Style,
                    ),
                  ),
                  SizedBox(
                    width: 177.w,
                    child: Baseline(
                      baseline: 30.h,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        description,
                        maxLines: 4,
                        style: sBodyText2Style.copyWith(
                          color: SColorsLight().grey1,
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   height: 48.h,
                  //   width: 177.w,
                  //   child: Baseline(
                  //     baseline: 20.h,
                  //     baselineType: TextBaseline.alphabetic,
                  //     child: Text(
                  //       header,
                  //       textAlign: TextAlign.start,
                  //       maxLines: 2,
                  //       style: sTextH5Style,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 177.w,
                  //   child: Baseline(
                  //     baseline: 30.h,
                  //     baselineType: TextBaseline.alphabetic,
                  //     child: Text(
                  //       description,
                  //       textAlign: TextAlign.start,
                  //       maxLines: 3,
                  //       style: sBodyText2Style.copyWith(
                  //         color: SColorsLight().grey1,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),

        // Positioned(
        //   top: 76,
        //   right: 0,
        //   child: Container(
        //     width: 327.w,
        //     height: 30.h,
        //     color: Colors.green,
        //   ),
        // ),
      ],
    );

    // Container(
    // width: 0.86.sw,
    // padding: EdgeInsets.all(15.r),
    // decoration: BoxDecoration(
    //   color: SColorsLight().blueLight,
    //   borderRadius: BorderRadius.circular(16.r),
    // ),
    // child: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //
    //
    //
    //     Text(
    //       header,
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,
    //       style: sTextH5Style,
    //     ),
    //     const SpaceH4(),
    //     Text(
    //       description,
    //       maxLines: 3,
    //       overflow: TextOverflow.ellipsis,
    //       style: sBodyText2Style,
    //     ),
    //   ],
    // ),
    //);
  }
}
