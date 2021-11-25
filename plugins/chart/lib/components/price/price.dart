import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  const Price(Key? key, this.price) : super(key: key);

  final double? price;

  @override
  Widget build(BuildContext context) {
    return price != null
        ? Column(
            children: [
              Text(
                price.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          )
        : Container();
  }
}
