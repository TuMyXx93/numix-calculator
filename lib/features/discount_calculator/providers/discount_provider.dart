import 'package:flutter/foundation.dart';

class DiscountCalculatorProvider extends ChangeNotifier {
  double? _finalPrice;
  double? _savedAmount;
  String? _errorMessage;

  double? get finalPrice => _finalPrice;
  double? get savedAmount => _savedAmount;
  String? get errorMessage => _errorMessage;

  void calculateDiscount(String originalPriceStr, String discountStr) {
    _errorMessage = null;

    final originalPrice = double.tryParse(originalPriceStr);
    final discount = double.tryParse(discountStr);

    if (originalPrice == null || discount == null) {
      _errorMessage = "Valores inválidos";
      _finalPrice = null;
      _savedAmount = null;
      notifyListeners();
      return;
    }

    if (originalPrice < 0 || discount < 0 || discount > 100) {
      _errorMessage = "El descuento debe estar entre 0 y 100, y el precio debe ser positivo";
      _finalPrice = null;
      _savedAmount = null;
      notifyListeners();
      return;
    }

    // Precise math consideration for formatting can be done in the UI
    // but we calculate the exact raw doubles here.
    _savedAmount = (originalPrice * discount) / 100;
    _finalPrice = originalPrice - _savedAmount!;
    
    notifyListeners();
  }

  void clear() {
    _finalPrice = null;
    _savedAmount = null;
    _errorMessage = null;
    notifyListeners();
  }
}
