part of '../basic_bottom_sheet.dart';

class BasicBottomSheetButton extends StatefulWidget {
  const BasicBottomSheetButton({
    required this.title,
    required this.onTap,
    this.withLoader = false,
    super.key,
  });

  final String title;
  final Function() onTap;
  final bool withLoader;

  @override
  State<BasicBottomSheetButton> createState() => _BasicBottomSheetButtonState();
}

class _BasicBottomSheetButtonState extends State<BasicBottomSheetButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
      ),
      child: SButton.blue(
        text: widget.title,
        callback: () {
          widget.onTap();
        },
      ),
    );
  }
}
