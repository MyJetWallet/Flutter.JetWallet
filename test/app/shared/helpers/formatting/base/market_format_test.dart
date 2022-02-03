import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jetwallet/app/shared/helpers/formatting/formatting.dart';

void main() {
  test('throws ArgumentError if negative accuracy', () {
    expect(
      () => marketFormat(
        decimal: Decimal.parse('0'),
        accuracy: -2,
        symbol: 'USD',
      ),
      throwsA(const TypeMatcher<ArgumentError>()),
    );
  });

  group('Symbol, prefix and negative sign', () {
    group('without accuracy', () {
      test('100 -> 100 USD', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 0,
          symbol: 'USD',
        );

        expect(result, '100 USD');
      });
      test('100 -> \$100', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 0,
          prefix: '\$',
          symbol: 'USD',
        );

        expect(result, '\$100');
      });
      test('100 -> 100 GBP', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 0,
          symbol: 'GBP',
        );

        expect(result, '100 GBP');
      });
      test('100 -> £100', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 0,
          prefix: '£',
          symbol: 'GBP',
        );

        expect(result, '£100');
      });
    });

    group('with accuracy', () {
      test('100 -> 100.00 USD', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 2,
          symbol: 'USD',
        );

        expect(result, '100.00 USD');
      });
      test('100 -> \$100.00', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 2,
          prefix: '\$',
          symbol: 'USD',
        );

        expect(result, '\$100.00');
      });
      test('100 -> 100.00 GBP', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 2,
          symbol: 'GBP',
        );

        expect(result, '100.00 GBP');
      });
      test('100 -> £100.00', () {
        final result = marketFormat(
          decimal: Decimal.parse('100'),
          accuracy: 2,
          prefix: '£',
          symbol: 'GBP',
        );

        expect(result, '£100.00');
      });
    });

    group('without accuracy and negative sign', () {
      test('100 -> -100 USD', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 0,
          symbol: 'USD',
        );

        expect(result, '-100 USD');
      });
      test('100 -> -\$100', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 0,
          prefix: '\$',
          symbol: 'USD',
        );

        expect(result, '-\$100');
      });
      test('100 -> -100 GBP', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 0,
          symbol: 'GBP',
        );

        expect(result, '-100 GBP');
      });
      test('100 -> -£100', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 0,
          prefix: '£',
          symbol: 'GBP',
        );

        expect(result, '-£100');
      });
    });

    group('with accuracy and negative sign', () {
      test('100 -> -100.00 USD', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 2,
          symbol: 'USD',
        );

        expect(result, '-100.00 USD');
      });
      test('100 -> -\$100.00', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 2,
          prefix: '\$',
          symbol: 'USD',
        );

        expect(result, '-\$100.00');
      });
      test('100 -> -100.00 GBP', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 2,
          symbol: 'GBP',
        );

        expect(result, '-100.00 GBP');
      });
      test('100 -> -£100.00', () {
        final result = marketFormat(
          decimal: Decimal.parse('-100'),
          accuracy: 2,
          prefix: '£',
          symbol: 'GBP',
        );

        expect(result, '-£100.00');
      });
    });
  });

  group('Zero cases', () {
    test('0 -> 0 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '0 USD');
    });
    test('0 -> 0.0 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0'),
        accuracy: 1,
        symbol: 'USD',
      );

      expect(result, '0.0 USD');
    });
    test('0 -> 0.00 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.00 USD');
    });
    test('0.0 -> 0.00 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.0'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.00 USD');
    });
    test('0.00 -> 0.00 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.00'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.00 USD');
    });
    test('0.000 -> 0.00 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.000'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.00 USD');
    });
    test('0.00000 -> 0.00 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.00000'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.00 USD');
    });
    test('0.00000 -> 0.000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.00000'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '0.000 USD');
    });
    test('0 -> 0.0000000000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0'),
        accuracy: 10,
        symbol: 'USD',
      );

      expect(result, '0.0000000000 USD');
    });
  });

  group('Rounding with decimal-point numbers', () {
    test('0.015 -> 0.02 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.015'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.02 USD');
    });

    test('0.025 -> 0.03 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('0.025'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '0.03 USD');
    });
    test('2.275 -> 2.28 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('2.275'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '2.28 USD');
    });
  });

  group('Genral rounding', () {
    test('34.2 -> 34 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.2'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '34 USD');
    });
    test('34.5 -> 35 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.5'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '35 USD');
    });
    test('34.91 -> 34.9 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.91'),
        accuracy: 1,
        symbol: 'USD',
      );

      expect(result, '34.9 USD');
    });
    test('34.95 -> 35.0 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.95'),
        accuracy: 1,
        symbol: 'USD',
      );

      expect(result, '35.0 USD');
    });
    test('34.999999 -> 35.00000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.999999'),
        accuracy: 5,
        symbol: 'USD',
      );

      expect(result, '35.00000 USD');
    });
    test('34.9210 -> 34.921 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9210'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.921 USD');
    });
    test('34.9211 -> 34.921 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9211'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.921 USD');
    });
    test('34.9212 -> 34.921 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9212'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.921 USD');
    });
    test('34.9213 -> 34.921 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9213'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.921 USD');
    });
    test('34.9214 -> 34.921 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9214'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.921 USD');
    });
    test('34.9215 -> 34.922 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9215'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.922 USD');
    });
    test('34.9216 -> 34.922 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9216'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.922 USD');
    });
    test('34.9217 -> 34.922 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9217'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.922 USD');
    });
    test('34.9218 -> 34.922 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9218'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.922 USD');
    });
    test('34.9219 -> 34.922 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('34.9219'),
        accuracy: 3,
        symbol: 'USD',
      );

      expect(result, '34.922 USD');
    });
  });
  test(
      '4.06000000700000029138931321209283 with precision 27 -> '
      '4.060000007000000291389313212', () {
    final result = marketFormat(
      decimal: Decimal.parse('4.06000000700000029138931321209283'),
      accuracy: 27,
      symbol: 'USD',
    );

    expect(result, '4.060000007000000291389313212 USD');
  });
  test(
      '3.06000000700000029100000321209283 with precision 28 -> '
      '3.0600000070000002910000032121', () {
    final result = marketFormat(
      decimal: Decimal.parse('3.06000000700000029100000321209283'),
      accuracy: 28,
      symbol: 'USD',
    );

    expect(result, '3.0600000070000002910000032121 USD');
  });

  group('Formatting the whole part without accuracy', () {
    test('1000 -> 1 000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('1000'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '1 000 USD');
    });
    test('10000 -> 10 000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('10000'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '10 000 USD');
    });
    test('100000 -> 100 000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('100000'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '100 000 USD');
    });
    test('1000000 -> 1 000 000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('1000000'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '1 000 000 USD');
    });
    test('10000000 -> 10 000 000 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('10000000'),
        accuracy: 0,
        symbol: 'USD',
      );

      expect(result, '10 000 000 USD');
    });
  });

  group('Formatting the whole part with accuracy', () {
    test('1000.92 -> 1 000.92 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('1000.92'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '1 000.92 USD');
    });
    test('10000.92 -> 10 000.92 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('10000.92'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '10 000.92 USD');
    });
    test('100000.92 -> 100 000.92 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('100000.92'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '100 000.92 USD');
    });
    test('1000000.92 -> 1 000 000.00.92 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('1000000.92'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '1 000 000.92 USD');
    });
    test('10000000.92 -> 10 000 000.00.92 USD', () {
      final result = marketFormat(
        decimal: Decimal.parse('10000000.92'),
        accuracy: 2,
        symbol: 'USD',
      );

      expect(result, '10 000 000.92 USD');
    });
  });
}
