import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/sales_price_provider.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _profitController = TextEditingController();
  final _taxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SalesPriceProvider>();
      if (provider.costInput.isNotEmpty) {
        _costController.text = provider.costInput;
        _profitController.text = provider.profitPercentInput;
        _taxController.text = provider.taxInput;
      }
    });
  }

  void _calculateSalePrice() {
    if (_formKey.currentState!.validate()) {
      context.read<SalesPriceProvider>().calculatePrice(
        costStr: _costController.text,
        profitPercentStr: _profitController.text,
        taxStr: _taxController.text,
      );
    }
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    _costController.dispose();
    _profitController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precio de Venta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _costController.clear();
              _profitController.clear();
              _taxController.clear();
              context.read<SalesPriceProvider>().clear();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tipo de Margen Toggle
              Consumer<SalesPriceProvider>(
                builder: (context, provider, child) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sobre Costo'),
                          Switch(
                            value: provider.marginType == MarginType.margin,
                            onChanged: (value) {
                              provider.setMarginType(
                                value ? MarginType.margin : MarginType.markup,
                              );
                              if (_costController.text.isNotEmpty && _profitController.text.isNotEmpty) {
                                _calculateSalePrice();
                              }
                            },
                          ),
                          const Text('Sobre Venta (Pro)'),
                        ],
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(
                          labelText: 'Costo Base del Producto',
                          prefixIcon: Icon(Icons.inventory),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el costo';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Costo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _profitController,
                        decoration: const InputDecoration(
                          labelText: 'Porcentaje de Ganancia (%)',
                          prefixIcon: Icon(Icons.trending_up),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el porcentaje';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Porcentaje inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _taxController,
                        decoration: const InputDecoration(
                          labelText: 'Impuestos / IVA (%) (Opcional)',
                          prefixIcon: Icon(Icons.account_balance),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _calculateSalePrice,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              Consumer<SalesPriceProvider>(
                builder: (context, provider, child) {
                  if (provider.errorMessage != null) {
                    return Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          provider.errorMessage!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  
                  if (provider.finalPrice != null) {
                    return Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Resumen Financiero',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Divider(),
                            _buildResultRow('Precio sin impuestos:', provider.baseSalePrice!),
                            _buildResultRow('Ganancia Neta:', provider.profitAmount!),
                            if (provider.taxAmount! > 0)
                              _buildResultRow('Impuestos:', provider.taxAmount!),
                            const Divider(),
                            Text(
                              'Precio Final (Venta): ${_formatCurrency(provider.finalPrice!)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            _formatCurrency(value),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
