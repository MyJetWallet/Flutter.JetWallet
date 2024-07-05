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
    String? subName2,
    bool expire = false,
  }) =>
      PaymentMethodBankCardWidget(
        network: network,
        name: name,
        subName: subName,
        subName2: subName2,
        onTap: onTap,
        expire: expire,
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
              SizedBox(
                height: 40,
                child: SNetworkCachedSvg(
                  url: url,
                  width: 40,
                  height: 40,
                  placeholder: MethodPlaceholder(
                    name: name,
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                height: 40,
                child: MethodPlaceholder(
                  name: name,
                ),
              ),
            ],
            const Spacer(),
            Text(
              name,
              style: sSubtitle3Style.copyWith(
                color: sKit.colors.black,
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
            const SizedBox(height: 1),
            Text(
              name,
              style: sSubtitle3Style.copyWith(
                color: sKit.colors.purple,
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
    required this.expire,
    this.subName2,
  });

  final CircleCardNetwork network;
  final String name;
  final String subName;
  final String? subName2;
  final Function() onTap;
  final bool expire;

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
                ],
              ),
            ),
            const SpaceH12(),
            Text(
              name,
              style: sSubtitle3Style.copyWith(
                color: sKit.colors.black,
              ),
            ),
            if (subName2 != null)
              Text(
                subName2 ?? '',
                style: sCaptionTextStyle.copyWith(
                  color: expire ? sKit.colors.red : sKit.colors.grey2,
                  height: 1.384,
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
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 102,
      ),
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
    this.width = 40,
    this.height = 40,
    required this.name,
  });

  final double width;
  final double height;

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
