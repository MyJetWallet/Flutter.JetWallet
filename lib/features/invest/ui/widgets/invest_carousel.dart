import 'package:flutter/material.dart';

class InvestCarousel extends StatelessWidget {
  const InvestCarousel({
    super.key,
    required this.children,
    this.margin = 12,
    this.height = 88,
    this.isSwitch = false,
  });

  final List<Widget> children;
  final double margin;
  final double height;
  final bool isSwitch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSwitch ? MediaQuery.of(context).size.width - 48 : MediaQuery.of(context).size.width - 24,
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              children[index],
              if (index + 1 != children.length)
                SizedBox(
                  width: margin,
                )
              else
                const SizedBox(
                  width: 24,
                ),
            ],
          );
        },
      ),
    );
  }
}
