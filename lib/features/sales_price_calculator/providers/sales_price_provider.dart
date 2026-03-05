import 'package:flutter/foundation.dart';

enum MarginType {
  markup, // Ganancia calculada sobre el costo (Markup)
  margin, // Ganancia calculada sobre el precio de venta (Gross Margin)
}

class SalesPriceProvider extends ChangeNotifier {
  double? _baseSalePrice; // Precio sin impuestos
  double? _finalPrice; // Precio con impuestos
  double? _profitAmount; // Cantidad de ganancia
  double? _taxAmount; // Cantidad de impuestos
  String? _errorMessage;

  MarginType _marginType = MarginType.markup;

  // Getters
  double? get baseSalePrice => _baseSalePrice;
  double? get finalPrice => _finalPrice;
  double? get profitAmount => _profitAmount;
  double? get taxAmount => _taxAmount;
  String? get errorMessage => _errorMessage;
  MarginType get marginType => _marginType;

  void setMarginType(MarginType type) {
    _marginType = type;
    notifyListeners();
  }

  void calculatePrice({
    required String costStr, 
    required String profitPercentStr, 
    String taxStr = '0',
  }) {
    _errorMessage = null;

    final cost = double.tryParse(costStr);
    final profitPercent = double.tryParse(profitPercentStr);
    final taxPercent = taxStr.isEmpty ? 0.0 : double.tryParse(taxStr);

    if (cost == null || profitPercent == null || taxPercent == null) {
      _errorMessage = "Valores numéricos inválidos";
      _clearResults();
      notifyListeners();
      return;
    }

    if (cost < 0 || profitPercent < 0 || taxPercent < 0) {
      _errorMessage = "Los valores no pueden ser negativos";
      _clearResults();
      notifyListeners();
      return;
    }

    if (_marginType == MarginType.margin && profitPercent >= 100) {
      _errorMessage = "El margen sobre venta debe ser menor a 100%";
      _clearResults();
      notifyListeners();
      return;
    }

    // Calcular precio base (sin impuestos) y ganancia
    if (_marginType == MarginType.markup) {
      // Markup: Ganancia = Costo * (Porcentaje / 100)
      _profitAmount = cost * (profitPercent / 100);
      _baseSalePrice = cost + _profitAmount!;
    } else {
      // Gross Margin: Precio = Costo / (1 - Porcentaje/100)
      _baseSalePrice = cost / (1 - (profitPercent / 100));
      _profitAmount = _baseSalePrice! - cost;
    }

    // Calcular impuestos
    _taxAmount = _baseSalePrice! * (taxPercent / 100);
    
    // Precio Final
    _finalPrice = _baseSalePrice! + _taxAmount!;

    notifyListeners();
  }

  void _clearResults() {
    _baseSalePrice = null;
    _finalPrice = null;
    _profitAmount = null;
    _taxAmount = null;
  }

  void clear() {
    _clearResults();
    _errorMessage = null;
    notifyListeners();
  }
}
