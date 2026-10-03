import 'package:flutter/material.dart';
import 'screens/company_profile.dart';
import 'screens/clients.dart';
import 'screens/saved_items.dart';
import 'screens/invoice_templates.dart';

void main() {
  runApp(const ProInvoiceApp());
}

class ProInvoiceApp extends StatelessWidget {
  const ProInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProInvoice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> invoices = [];

  Future<void> createInvoice() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewInvoicePage(),
      ),
    );

    if (result != null) {
      setState(() {
        invoices.add(result);
      });
    }
  }

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ProInvoice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: openSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: invoices.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No invoices yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Tap + to create your first invoice'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.receipt),
                    ),
                    title: Text(
                      invoice['invoiceNumber'] ?? 'Invoice',
                    ),
                    subtitle: Text(
                      invoice['client']?.isNotEmpty == true
                          ? invoice['client']
                          : 'No client',
                    ),
                    trailing: Text(
                      '£${(invoice['total'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createInvoice,
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void openPage(
    BuildContext context,
    Widget page,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Company Profile'),
            subtitle: const Text(
              'Business name, address, phone and VAT',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              openPage(
                context,
                const CompanyProfilePage(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clients'),
            subtitle: const Text(
              'Manage your saved clients',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              openPage(
                context,
                const ClientsPage(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Saved Items'),
            subtitle: const Text(
              'Save labour, parts and other items',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              openPage(
                context,
                const SavedItemsPage(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Invoice Templates'),
            subtitle: const Text(
              'Choose your invoice design',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              openPage(
                context,
                const InvoiceTemplatesPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InvoiceItem {
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController priceController;

  InvoiceItem()
      : descriptionController = TextEditingController(),
        quantityController = TextEditingController(text: '1'),
        priceController = TextEditingController();

  double get quantity =>
      double.tryParse(quantityController.text) ?? 0;

  double get price =>
      double.tryParse(priceController.text) ?? 0;

  double get total => quantity * price;

  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }
}

class NewInvoicePage extends StatefulWidget {
  const NewInvoicePage({super.key});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final clientController = TextEditingController();
  final emailController = TextEditingController();
  final jobNumberController = TextEditingController();

  final List<InvoiceItem> items = [
    InvoiceItem(),
  ];

  double vatRate = 20.0;

  double get subtotal {
    return items.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  double get vat {
    return subtotal * vatRate / 100;
  }

  double get total {
    return subtotal + vat;
  }

  void addItem() {
    setState(() {
      items.add(InvoiceItem());
    });
  }

  void removeItem(int index) {
    if (items.length == 1) {
      return;
    }

    setState(() {
      items[index].dispose();
      items.removeAt(index);
    });
  }

  void saveInvoice() {
    final invoiceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    Navigator.pop(
      context,
      {
        'invoiceNumber': invoiceNumber,
        'client': clientController.text.trim(),
        'total': total,
      },
    );
  }

  @override
  void dispose() {
    clientController.dispose();
    emailController.dispose();
    jobNumberController.dispose();

    for (final item in items) {
      item.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: clientController,
            decoration: const InputDecoration(
              labelText: 'Client Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Client Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: jobNumberController,
            decoration: const InputDecoration(
              labelText: 'Order / Job Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...items.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final item = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: item.descriptionController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: item.quantityController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Qty',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: TextField(
                              controller: item.priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Unit Price',
                                prefixText: '£ ',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Line Total: £${item.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (items.length > 1)
                            IconButton(
                              onPressed: () => removeItem(index),
                              icon: const Icon(
                                Icons.delete_outline,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          DropdownButtonFormField<double>(
            initialValue: vatRate,
            decoration: const InputDecoration(
              labelText: 'VAT',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 0.0,
                child: Text('0%'),
              ),
              DropdownMenuItem(
                value: 5.0,
                child: Text('5%'),
              ),
              DropdownMenuItem(
                value: 20.0,
                child: Text('20%'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  vatRate = value;
                });
              }
            },
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _totalRow(
                    'Subtotal',
                    subtotal,
                  ),
                  _totalRow(
                    'VAT',
                    vat,
                  ),
                  const Divider(),
                  _totalRow(
                    'Total',
                    total,
                    bold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: saveInvoice,
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Invoice',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
    String label,
    double amount, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 16,
            ),
          ),
          Text(
            '£${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
}