import 'package:flutter/foundation.dart';

enum DiscountType {
  percentage, // Descuento en porcentaje (%)
  fixedAmount, // Descuento en monto fijo ($)
}

class DiscountCalculatorProvider extends ChangeNotifier {
  double? _subtotal; // Precio después de descuentos, antes de impuestos
  double? _finalPrice; // Precio final con impuestos
  double? _savedAmount; // Total ahorrado
  double? _taxAmount; // Monto de impuestos a pagar
  String? _errorMessage;

  DiscountType _discountType = DiscountType.percentage;

  // Getters
  double? get subtotal => _subtotal;
  double? get finalPrice => _finalPrice;
  double? get savedAmount => _savedAmount;
  double? get taxAmount => _taxAmount;
  String? get errorMessage => _errorMessage;
  DiscountType get discountType => _discountType;

  void setDiscountType(DiscountType type) {
    _discountType = type;
    notifyListeners();
  }

  void calculateDiscount({
    required String originalPriceStr,
    required String primaryDiscountStr,
    String additionalDiscountStr = '',
    String taxStr = '',
  }) {
    _errorMessage = null;

    final originalPrice = double.tryParse(originalPriceStr);
    final primaryDiscount = double.tryParse(primaryDiscountStr);
    final additionalDiscount = additionalDiscountStr.isEmpty ? 0.0 : double.tryParse(additionalDiscountStr);
    final taxPercent = taxStr.isEmpty ? 0.0 : double.tryParse(taxStr);

    if (originalPrice == null || primaryDiscount == null || additionalDiscount == null || taxPercent == null) {
      _errorMessage = "Valores numéricos inválidos";
      _clearResults();
      notifyListeners();
      return;
    }

    if (originalPrice < 0 || primaryDiscount < 0 || additionalDiscount < 0 || taxPercent < 0) {
      _errorMessage = "Los valores no pueden ser negativos";
      _clearResults();
      notifyListeners();
      return;
    }

    double currentPrice = originalPrice;
    double totalSaved = 0.0;

    if (_discountType == DiscountType.percentage) {
      if (primaryDiscount > 100 || additionalDiscount > 100) {
        _errorMessage = "Los porcentajes de descuento no pueden exceder 100%";
        _clearResults();
        notifyListeners();
        return;
      }

      // Descuento en cascada (Sucesivos)
      double saved1 = currentPrice * (primaryDiscount / 100);
      currentPrice -= saved1;
      totalSaved += saved1;

      if (additionalDiscount > 0) {
        double saved2 = currentPrice * (additionalDiscount / 100);
        currentPrice -= saved2;
        totalSaved += saved2;
      }
    } else {
      // Monto fijo
      double totalFixedDiscount = primaryDiscount + additionalDiscount;
      if (totalFixedDiscount > originalPrice) {
        _errorMessage = "El descuento no puede ser mayor al precio original";
        _clearResults();
        notifyListeners();
        return;
      }
      totalSaved = totalFixedDiscount;
      currentPrice = originalPrice - totalFixedDiscount;
    }

    _savedAmount = totalSaved;
    _subtotal = currentPrice;

    // Calcular impuestos
    _taxAmount = _subtotal! * (taxPercent / 100);
    _finalPrice = _subtotal! + _taxAmount!;

    notifyListeners();
  }

  void _clearResults() {
    _subtotal = null;
    _finalPrice = null;
    _savedAmount = null;
    _taxAmount = null;
  }

  void clear() {
    _clearResults();
    _errorMessage = null;
    notifyListeners();
  }
}
