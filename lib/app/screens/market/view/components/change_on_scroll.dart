import 'dart:developer';

import 'package:flutter/material.dart';

class ChangeOnScroll extends StatefulWidget {
  const ChangeOnScroll({
    required this.scrollController,
    required this.changeOutWidget,
    required this.changeInWidget,
    required this.permanentWidget,
    this.zeroOpacityOffset = 0,
    this.fullOpacityOffset = 0,
  });

  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget changeOutWidget;
  final Widget changeInWidget;
  final Widget permanentWidget;

  @override
  _ChangeOnScrollState createState() => _ChangeOnScrollState();
}

class _ChangeOnScrollState extends State<ChangeOnScroll> {
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

  bool _needToHideOutWidget() {
    log('_offset: $_offset');
    log('fullOpacityOffset: ${widget.fullOpacityOffset}');
    return widget.fullOpacityOffset < _offset;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_needToHideOutWidget())
          widget.changeInWidget,
        if (!_needToHideOutWidget())
          widget.changeOutWidget,
      ],
    );
  }
}
