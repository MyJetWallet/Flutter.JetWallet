import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

part 'widgets/basic_bottom_sheet_button_widget.dart';

part 'widgets/basic_bottom_sheet_header_widget.dart';

class BasicBottomSheet extends StatefulWidget {
  const BasicBottomSheet({
    required this.children,
    required this.header,
    this.button,
    this.onDismiss,
    this.onWillPop,
    required this.color,
    this.title,
    required this.topPadding,
    required this.bottomPadding,
    super.key,
  });

  final List<Widget> children;
  final BasicBottomSheetHeaderWidget header;
  final BasicBottomSheetButton? button;
  final Function()? onDismiss;
  final Future Function(bool)? onWillPop;
  final Color color;
  final String? title;
  final double topPadding;
  final double bottomPadding;

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
    final double buttonBottomPadding = widget.bottomPadding + (widget.bottomPadding < 24.0 ? 8 : 0) + 16.0;

    Widget buttonPlaceholder = const SizedBox();
    if (contentTooBig) {
      buttonPlaceholder = SizedBox(
        height: buttonBottomPadding + buttonHeight + 32.0,
      );
    } else {
      buttonPlaceholder = const SizedBox();
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
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
                  BasicBottomSheetHeaderWidget(
                    title: widget.title ?? widget.header.title,
                    searchOptions: widget.header.searchOptions,
                  ),
                  if (contentTooBig)
                    SizedBox(
                      height: MediaQuery.of(context).size.height - widget.topPadding - 20 - _getHeaderHeight(),
                      child: Stack(
                        children: [
                          DraggableScrollableSheet(
                            initialChildSize: 1,
                            minChildSize: 0.95,
                            maxChildSize: 1.0,
                            builder: (context, scrollController) {
                              return ListView(
                                controller: scrollController,
                                children: [
                                  Column(
                                    key: _contentKey,
                                    children: [
                                      ...widget.children,
                                      buttonPlaceholder,
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          if (widget.button != null)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: buttonBottomPadding),
                                child: widget.button,
                              ),
                            ),
                        ],
                      ),
                    )
                  else
                    Column(
                      key: _contentKey,
                      children: [
                        ...widget.children,
                        if (widget.button != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: buttonBottomPadding),
                            child: widget.button,
                          ),
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

    final screenHeight = MediaQuery.of(context).size.height - widget.topPadding - 20 - _getHeaderHeight();

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

  double _getHeaderHeight() {
    final double titleHeight = (widget.title != null
        ? (31 + 24)
        : widget.header.title != null
            ? (31 + 24)
            : 0);
    final double searchHeight = (widget.header.searchOptions != null ? (60) : 0);

    return 8 + 6 + 24 + titleHeight + searchHeight;
  }
}
