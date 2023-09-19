import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/rewards_flow/ui/reward_open_screen.dart';
import 'package:jetwallet/features/rewards_flow/ui/widgets/reward_closed_card.dart';

class RewardAnimatedCard extends StatefulObserverWidget {
  const RewardAnimatedCard({
    super.key,
    required this.cardID,
    required this.offsetX,
    required this.offsetY,
    required this.source,
  });

  final int cardID;
  final double offsetX;
  final double offsetY;
  final String source;

  @override
  State<RewardAnimatedCard> createState() => _RewardAnimatedCardState();
}

class _RewardAnimatedCardState extends State<RewardAnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animationX;
  late Animation<double> animationY;

  @override
  void initState() {
    super.initState();
    // Card 1
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationX = Tween(begin: 0.0, end: widget.offsetX).animate(_controller);
    animationY = Tween(begin: 0.0, end: widget.offsetY).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    final store = RewardOpenStore.of(context);

    store.updateLastController(_controller);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final store = RewardOpenStore.of(context);

    return AnimatedBuilder(
      animation: _controller,
      child: AnimatedOpacity(
        opacity: store.showCard(widget.cardID) ? 1 : 0,
        duration: const Duration(milliseconds: 350),
        child: AnimatedContainer(
          width: store.showCard(widget.cardID) ? store.width : 155,
          height: store.showCard(widget.cardID) ? store.height : 200,
          duration: const Duration(seconds: 1),
          child: GestureDetector(
            onTap: () {
              store.openCard(widget.cardID, _controller, widget.source);
            },
            child: RewardClosedCard(
              //controller: cardController1,
              controller: store.getFlipController(widget.cardID),
              type: widget.cardID,
              spinData: store.spinData,
              shareKey: store.getKey(widget.cardID),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animationX.value, animationY.value),
          child: child,
        );
      },
    );
  }
}
