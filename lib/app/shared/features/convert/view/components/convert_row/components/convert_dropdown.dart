import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../screens/market/model/currency_model.dart';

class ConvertDropdown extends StatelessWidget {
  const ConvertDropdown({
    Key? key,
    required this.value,
    required this.currencies,
    required this.onChanged,
  }) : super(key: key);

  final CurrencyModel value;
  final List<CurrencyModel> currencies;
  final Function(CurrencyModel?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CurrencyModel>(
      value: value,
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      iconEnabledColor: Colors.black,
      dropdownColor: Colors.white,
      underline: const SizedBox(),
      items: [
        for (final i in currencies)
          DropdownMenuItem(
            value: i,
            child: Text(
              i.symbol,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
