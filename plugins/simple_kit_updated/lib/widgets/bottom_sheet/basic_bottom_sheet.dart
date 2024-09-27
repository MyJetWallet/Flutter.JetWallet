import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showBasicBottomSheet({
  required BuildContext context,
  required List<Widget> children,
  BasicBottomSheetButton? basicBottomSheetButton,
  Function()? onDismiss,
  bool isDismissible = true,
  Future Function(bool)? onWillPop,
  Color? color,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    enableDrag: false,
    useSafeArea: true,
    builder: (context) {
      return BasicBottomSheet(
        button: basicBottomSheetButton,
        onDismiss: onDismiss,
        onWillPop: onWillPop,
        color: color ?? SColorsLight().white,
        children: children,
      );
    },
  );
}

class BasicBottomSheet extends StatefulWidget {
  const BasicBottomSheet({
    required this.children,
    this.button,
    this.onDismiss,
    this.onWillPop,
    required this.color,
    super.key,
  });

  final List<Widget> children;
  final BasicBottomSheetButton? button;
  final Function()? onDismiss;
  final Future Function(bool)? onWillPop;
  final Color color;

  @override
  State<BasicBottomSheet> createState() => _BasicBottomSheetState();
}

class _BasicBottomSheetState extends State<BasicBottomSheet> {
  final GlobalKey _contentKey = GlobalKey();
  double buttonHeight = 56.0;

  bool contentTooBig = false;

  bool isClosing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkContentSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonPlaceholder = const SizedBox();
    if (contentTooBig) {
      buttonPlaceholder = SizedBox(
        height: 48.0 + buttonHeight,
      );
    } else {
      buttonPlaceholder = const SizedBox();
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) return;
        widget.onWillPop ?? onDismissAction(context);
      },
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          children: [
            SizedBox(
              height: 20,
              child: GestureDetector(
                onTap: () => onDismissAction(context),
              ),
            ),
            if (!contentTooBig)
              Expanded(
                child: GestureDetector(
                  onTap: () => onDismissAction(context),
                ),
              ),
            Material(
              color: widget.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  const _BasicHeader(),
                  const SizedBox(
                    height: 24.0,
                  ),
                  if (contentTooBig)
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 20 - 32 - 6 - 20,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              key: _contentKey,
                              children: [
                                ...widget.children,
                                buttonPlaceholder,
                              ],
                            ),
                          ),
                          if (widget.button != null)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: widget.button,
                            ),
                        ],
                      ),
                    )
                  else
                    Column(
                      key: _contentKey,
                      children: [
                        ...widget.children,
                        widget.button ?? const SizedBox(),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkContentSize() {
    final RenderBox contentBox = _contentKey.currentContext?.findRenderObject() as RenderBox;
    final contentHeight = contentBox.size.height;

    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      contentTooBig = contentHeight > screenHeight;
    });
  }

  void onDismissAction(BuildContext context) {
    if (!isClosing) {
      setState(() {
        isClosing = true;
      });

      widget.onDismiss?.call();
      Navigator.pop(context);
    }
  }
}

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
      margin: const EdgeInsets.all(24.0),
      child: SButton.blue(
        text: widget.title,
        callback: () {
          widget.onTap();
        },
      ),
    );
  }
}

class _BasicHeader extends StatelessWidget {
  const _BasicHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 6,
      decoration: ShapeDecoration(
        color: SColorsLight().gray4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
