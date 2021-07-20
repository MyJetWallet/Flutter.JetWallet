import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Colors.grey.shade100,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: const Icon(Icons.search),
        color: Colors.grey.shade600,
        onPressed: () {},
      ),
    );
  }
}
