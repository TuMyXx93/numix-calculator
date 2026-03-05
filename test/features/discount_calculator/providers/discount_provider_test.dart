import 'package:flutter_test/flutter_test.dart';
import 'package:numix/features/discount_calculator/providers/discount_provider.dart';

void main() {
  group('DiscountCalculatorProvider', () {
    late DiscountCalculatorProvider provider;

    setUp(() {
      provider = DiscountCalculatorProvider();
    });

    test('Initial values are null', () {
      expect(provider.finalPrice, isNull);
      expect(provider.savedAmount, isNull);
      expect(provider.errorMessage, isNull);
    });

    test('Calculates discount correctly', () {
      provider.calculateDiscount('100', '20');

      expect(provider.errorMessage, isNull);
      expect(provider.savedAmount, 20.0);
      expect(provider.finalPrice, 80.0);
    });

    test('Calculates discount correctly with decimals', () {
      provider.calculateDiscount('150.50', '15.5');

      expect(provider.errorMessage, isNull);
      expect(provider.savedAmount, closeTo(23.3275, 0.001));
      expect(provider.finalPrice, closeTo(127.1725, 0.001));
    });

    test('Sets error message for invalid number format', () {
      provider.calculateDiscount('abc', '20');

      expect(provider.errorMessage, 'Valores inválidos');
      expect(provider.savedAmount, isNull);
      expect(provider.finalPrice, isNull);
    });

    test('Sets error message for empty strings', () {
      provider.calculateDiscount('', '');

      expect(provider.errorMessage, 'Valores inválidos');
      expect(provider.savedAmount, isNull);
      expect(provider.finalPrice, isNull);
    });

    test('Sets error message for negative original price', () {
      provider.calculateDiscount('-100', '20');

      expect(provider.errorMessage, 'El descuento debe estar entre 0 y 100, y el precio debe ser positivo');
      expect(provider.savedAmount, isNull);
      expect(provider.finalPrice, isNull);
    });

    test('Sets error message for discount greater than 100', () {
      provider.calculateDiscount('100', '110');

      expect(provider.errorMessage, 'El descuento debe estar entre 0 y 100, y el precio debe ser positivo');
      expect(provider.savedAmount, isNull);
      expect(provider.finalPrice, isNull);
    });

    test('Sets error message for negative discount', () {
      provider.calculateDiscount('100', '-10');

      expect(provider.errorMessage, 'El descuento debe estar entre 0 y 100, y el precio debe ser positivo');
      expect(provider.savedAmount, isNull);
      expect(provider.finalPrice, isNull);
    });

    test('Clears values correctly', () {
      provider.calculateDiscount('100', '20');
      provider.clear();

      expect(provider.finalPrice, isNull);
      expect(provider.savedAmount, isNull);
      expect(provider.errorMessage, isNull);
    });
  });
}
