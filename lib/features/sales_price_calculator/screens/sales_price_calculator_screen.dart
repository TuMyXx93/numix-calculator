import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _profitController = TextEditingController();
  double? _salePrice;
  double? _profitAmount;

  void _calculateSalePrice() {
    if (_formKey.currentState!.validate()) {
      final cost = double.parse(_costController.text);
      final profitPercentage = double.parse(_profitController.text);
      
      setState(() {
        _profitAmount = (cost * profitPercentage) / 100;
        _salePrice = cost + _profitAmount!;
      });
    }
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    _costController.dispose();
    _profitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Precio de Venta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(
                          labelText: 'Costo del Producto',
                          prefixIcon: Icon(Icons.inventory),
                          border: OutlineInputBorder(),
                          hintText: 'Ingrese el costo del producto',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el costo';
                          }
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return 'Por favor ingrese un costo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _profitController,
                        decoration: const InputDecoration(
                          labelText: 'Porcentaje de Ganancia',
                          prefixIcon: Icon(Icons.trending_up),
                          border: OutlineInputBorder(),
                          hintText: 'Ingrese el porcentaje de ganancia',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el porcentaje';
                          }
                          final profit = double.tryParse(value);
                          if (profit == null || profit < 0) {
                            return 'Por favor ingrese un porcentaje válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _calculateSalePrice,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular Precio de Venta'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              if (_salePrice != null) ...[
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Precio de Venta: ${_formatCurrency(_salePrice!)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ganancia: ${_formatCurrency(_profitAmount!)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
