import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldSuffix extends StatelessWidget {
  const SearchFieldSuffix({
    Key? key,
    required this.onErase,
    required this.showErase,
  }) : super(key: key);

  final Function() onErase;
  final bool showErase;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: showErase ? 30.w : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showErase)
            Expanded(
              child: InkWell(
                onTap: onErase,
                child: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 22.r,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
