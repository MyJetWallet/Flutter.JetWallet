import 'dart:math';

import 'package:decimal/decimal.dart';

List<Decimal> calculateAmountPositions({
  required Decimal balance,
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  final maxFromBoth = balance > maxVolume ? maxVolume : balance;
  final lvl5 = rounderByNum(maxFromBoth) * Decimal.fromBigInt((maxFromBoth / rounderByNum(maxFromBoth)).floor());

  final lvl1 = minVolume > lvl5 * Decimal.fromJson('0.01') ? minVolume : lvl5 * Decimal.fromJson('0.01');

  final preLn1 = log(lvl1.toDouble());
  final preLn5 = log(lvl5.toDouble());

  final preLn2 = (preLn5 - preLn1) / 4 + preLn1;
  final preLn3 = (preLn5 - preLn1) / 2 + preLn1;
  final preLn4 = 3 * (preLn5 - preLn1) / 4 + preLn1;

  final preLvl2 = Decimal.fromJson('${exp(preLn2)}');
  final preLvl3 = Decimal.fromJson('${exp(preLn3)}');
  final preLvl4 = Decimal.fromJson('${exp(preLn4)}');

  final lvl2 = rounderByNum(preLvl2) * Decimal.fromBigInt((preLvl2 / rounderByNum(preLvl2)).ceil());
  final lvl3 = rounderByNum(preLvl3) * Decimal.fromBigInt((preLvl3 / rounderByNum(preLvl3)).ceil());
  final lvl4 = rounderByNum(preLvl4) * Decimal.fromBigInt((preLvl4 / rounderByNum(preLvl4)).ceil());

  return [lvl1, lvl2, lvl3, lvl4, lvl5];
}

Decimal calculateAmountMin({
  required Decimal balance,
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  final maxFromBoth = balance > maxVolume ? maxVolume : balance;
  final lvl5 = rounderByNum(maxFromBoth) * Decimal.fromBigInt((maxFromBoth / rounderByNum(maxFromBoth)).floor());

  final lvl1 = minVolume > lvl5 * Decimal.fromJson('0.01') ? minVolume : lvl5 * Decimal.fromJson('0.01');

  final preLn1 = log(lvl1.toDouble());

  return Decimal.fromJson('$preLn1');
}

Decimal calculateAmountMinReal({
  required Decimal balance,
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  final maxFromBoth = balance > maxVolume ? maxVolume : balance;
  final lvl5 = rounderByNum(maxFromBoth) * Decimal.fromBigInt((maxFromBoth / rounderByNum(maxFromBoth)).floor());

  final lvl1 = minVolume > lvl5 * Decimal.fromJson('0.01') ? minVolume : lvl5 * Decimal.fromJson('0.01');

  return lvl1;
}

Decimal calculateAmountMaxReal({
  required Decimal balance,
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  final maxFromBoth = balance > maxVolume ? maxVolume : balance;
  final lvl5 = rounderByNum(maxFromBoth) * Decimal.fromBigInt((maxFromBoth / rounderByNum(maxFromBoth)).floor());

  return lvl5;
}

Decimal calculateAmountMax({
  required Decimal balance,
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  final maxFromBoth = balance > maxVolume ? maxVolume : balance;
  final lvl5 = rounderByNum(maxFromBoth) * Decimal.fromBigInt((maxFromBoth / rounderByNum(maxFromBoth)).floor());

  final preLn5 = log(lvl5.toDouble());

  return Decimal.fromJson('$preLn5');
}

List<Decimal> calculateMultiplyPositions({
  required Decimal minVolume,
  required Decimal maxVolume,
}) {
  if (maxVolume == Decimal.ten) {
    return [
      Decimal.fromInt(1),
      Decimal.fromInt(2),
      Decimal.fromInt(5),
      Decimal.fromInt(8),
      Decimal.fromInt(10),
    ];
  }

  final doubleMax = maxVolume.toDouble();

  final lvl2 = (doubleMax / 4 / 5).floor() * 5;
  final lvl3 = (doubleMax / 2 / 5).floor() * 5;
  final lvl4 = (3 * doubleMax / 4 / 5).floor() * 5;

  return [
    minVolume,
    Decimal.fromJson('$lvl2'),
    Decimal.fromJson('$lvl3'),
    Decimal.fromJson('$lvl4'),
    maxVolume,
  ];
}

List<Decimal> calculateLimitsPositions({
  required Decimal price,
  required Decimal amount,
  required List<Decimal> limits,
  required bool isAmount,
  required bool isSl,
}) {
  var arrayToReturn = <Decimal>[];

  if (isAmount) {
    arrayToReturn = limits.map((e) {
      if (isSl) {
        return (amount * e * Decimal.fromInt(-1)).floor();
      }

      return (amount * e).floor();
    }).toList();
  } else if (!isAmount) {
    arrayToReturn = limits.map((e) {
      if (isSl) {
        return price + price * e * Decimal.fromInt(-1);
      }

      return price + price * e;
    }).toList();
  }

  return arrayToReturn;
}

Decimal rounderByNum(Decimal numToCheck) {
  if (numToCheck <= Decimal.fromInt(30)) {
    return Decimal.fromInt(5);
  } else if (numToCheck <= Decimal.fromInt(100)) {
    return Decimal.fromInt(10);
  } else if (numToCheck <= Decimal.fromInt(200)) {
    return Decimal.fromInt(20);
  } else if (numToCheck <= Decimal.fromInt(500)) {
    return Decimal.fromInt(50);
  } else if (numToCheck <= Decimal.fromInt(1000)) {
    return Decimal.fromInt(100);
  } else {
    return Decimal.fromInt(500);
  }
}
