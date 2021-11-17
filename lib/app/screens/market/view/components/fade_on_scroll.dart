import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class FadeOnScroll extends StatefulWidget {
  const FadeOnScroll({
    required this.scrollController,
    required this.fadeOutWidget,
    required this.fadeInWidget,
    required this.permanentWidget,
    this.zeroOpacityOffset = 0,
    this.fullOpacityOffset = 0,
  });

  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget fadeOutWidget;
  final Widget fadeInWidget;
  final Widget permanentWidget;

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  late double _offset;

  @override
  void initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateFadeInOpacity() {
    if (widget.fullOpacityOffset == widget.zeroOpacityOffset) {
      return 1;
    } else if (widget.fullOpacityOffset > widget.zeroOpacityOffset) {
      // fading in
      if (_offset <= widget.zeroOpacityOffset) {
        return 0;
      } else if (_offset >= widget.fullOpacityOffset) {
        return 1;
      } else {
        return 0;
      }
    } else {
      // fading out
      if (_offset <= widget.fullOpacityOffset) {
        return 1;
      } else if (_offset >= widget.zeroOpacityOffset) {
        return 0;
      } else {
        return (_offset - widget.fullOpacityOffset) /
            (widget.zeroOpacityOffset - widget.fullOpacityOffset);
      }
    }
  }

  double _calculateFadeOutOpacity() {
    if (widget.fullOpacityOffset == widget.zeroOpacityOffset) {
      return 1;
    } else if (widget.fullOpacityOffset > widget.zeroOpacityOffset) {
      // fading in
      if (_offset <= widget.zeroOpacityOffset) {
        return 1;
      } else if (_offset >= widget.fullOpacityOffset) {
        return 0;
      } else {
        return (_offset - widget.fullOpacityOffset) /
            (widget.zeroOpacityOffset - widget.fullOpacityOffset);
      }
    } else {
      // fading out
      if (_offset <= widget.fullOpacityOffset) {
        return 1;
      } else if (_offset >= widget.zeroOpacityOffset) {
        return 0;
      } else {
        return (_offset - widget.fullOpacityOffset) /
            (widget.zeroOpacityOffset - widget.fullOpacityOffset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: _calculateFadeInOpacity(),
            child: widget.fadeInWidget,
          ),
        ),
        SMarketHeaderClosed(
          title: 'Market',
          onSearchButtonTap: () {},
        ),
        Opacity(
          opacity: _calculateFadeOutOpacity(),
          child: widget.fadeOutWidget,
        ),
      ],
    );
  }
}
