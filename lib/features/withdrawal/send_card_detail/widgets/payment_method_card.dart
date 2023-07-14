import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

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

  static Widget bankCard({
    required CircleCardNetwork network,
    required String name,
    required String subName,
    required Function() onTap,
  }) =>
      PaymentMethodBankCardWidget(
        network: network,
        name: name,
        subName: subName,
        onTap: onTap,
      );

  static Widget cardIcon({
    required Widget icon,
    required String name,
    required Function() onTap,
  }) =>
      PaymentMethodCardIconWidget(
        icon: icon,
        name: name,
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
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: _BaseContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (url.isNotEmpty) ...[
              SNetworkCachedSvg(
                url: url,
                width: 40,
                height: 40,
                placeholder: MethodPlaceholder(
                  name: name,
                ),
              ),
            ] else ...[
              MethodPlaceholder(
                name: name,
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

class PaymentMethodCardIconWidget extends StatelessWidget {
  const PaymentMethodCardIconWidget({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  final Widget icon;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: _BaseContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 12),
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

class PaymentMethodBankCardWidget extends StatelessWidget {
  const PaymentMethodBankCardWidget({
    super.key,
    required this.network,
    required this.name,
    required this.subName,
    required this.onTap,
  });

  final CircleCardNetwork network;
  final String name;
  final String subName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: _BaseContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: getNetworkIcon(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subName,
                    style: sOverlineTextStyle.copyWith(
                      color: sKit.colors.grey2,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget getNetworkIcon() {
    switch (network) {
      case CircleCardNetwork.VISA:
        return const SVisaCardIcon(
          width: 40,
          height: 25,
        );
      case CircleCardNetwork.MASTERCARD:
        return const SMasterCardIcon(
          width: 40,
          height: 25,
        );
      default:
        return SizedBox(
          width: 40,
          height: 25,
          child: Center(
            child: SActionDepositIcon(
              color: sKit.colors.blue,
            ),
          ),
        );
    }
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
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

class MethodPlaceholder extends StatelessWidget {
  const MethodPlaceholder({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: sKit.colors.grey4,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.only(bottom: 4),
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '' : name[0].toUpperCase(),
        style: sSubtitle1Style.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
