import 'package:flutter/material.dart';

class DocumentPageView extends StatelessWidget {
  const DocumentPageView({
    super.key,
    required this.onPageChanged,
    required this.pageController,
    required this.itemCount,
    required this.banners,
  });

  final PageController pageController;
  final Function(int) onPageChanged;
  final int itemCount;
  final List<Widget> banners;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: itemCount,
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
            ),
            child: banners[index],
          );
        },
      ),
    );
  }
}
