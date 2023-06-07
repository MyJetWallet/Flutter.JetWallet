import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

// ignore: avoid_classes_with_only_static_members
class PaymentMethodCard {
  static Widget card({
    required String name,
    required String url,
    required Function() onTap,
  }) =>
      PaymentMethodCardWidget(
        name: name,
        url: url,
        onTap: onTap,
      );

  static Widget skeleton() => const PaymentMethodCardSkeleton();
}

class PaymentMethodCardWidget extends StatelessWidget {
  const PaymentMethodCardWidget({
    super.key,
    required this.name,
    required this.url,
    required this.onTap,
  });

  final String name;
  final String url;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: _BaseContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (url.isNotEmpty) ...[
              Image.network(
                'src,',
                width: 40,
                height: 40,
              ),
            ] else ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0.5156, 1],
                    colors: [
                      sKit.colors.grey4,
                      sKit.colors.grey5,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.only(bottom: 4),
                alignment: Alignment.center,
                child: Text(
                  name[0],
                  style: sSubtitle1Style,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              name,
              style: sBodyText2Style.copyWith(
                color: sKit.colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodCardSkeleton extends StatelessWidget {
  const PaymentMethodCardSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SSkeletonTextLoader(
            height: 40,
            width: 40,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 22.5),
          const SSkeletonTextLoader(
            height: 8,
            width: 88,
          ),
        ],
      ),
    );
  }
}

class _BaseContainer extends StatelessWidget {
  const _BaseContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: sKit.colors.grey4,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
