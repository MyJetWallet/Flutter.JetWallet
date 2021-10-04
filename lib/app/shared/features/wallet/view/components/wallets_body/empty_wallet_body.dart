import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../shared/components/spacers.dart';


class EmptyWalletBody extends StatelessWidget {
  const EmptyWalletBody({
    Key? key,
    required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'All $assetName transaction',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const SpaceH8(),
              const Text(
                'Your transactions will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
