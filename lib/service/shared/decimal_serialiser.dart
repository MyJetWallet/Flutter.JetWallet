import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

class DecimalSerialiser implements JsonConverter<Decimal, dynamic> {
  const DecimalSerialiser();

  @override
  Decimal fromJson(dynamic json) => Decimal.parse(json.toString());

  @override
  dynamic toJson(Decimal decimal) => decimal.toDouble();
}
