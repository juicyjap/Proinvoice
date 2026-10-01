import 'package:flutter/material.dart';

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

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> invoices = [];

  Future<void> createInvoice() async {
    final invoice = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const NewInvoicePage(),
      ),
    );

    if (invoice != null) {
      setState(() {
        invoices.add(invoice);
      });
    }
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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),

      body: invoices.isEmpty
          ? _emptyDashboard()
          : _invoiceList(),

      // ONE new invoice button only.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createInvoice,
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
      ),
    );
  }

  Widget _emptyDashboard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.receipt_long,
                size: 55,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'No invoices yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Your invoices will appear here.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Your invoices',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          '${invoices.length} invoice${invoices.length == 1 ? '' : 's'}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 20),

        ...invoices.map(
          (invoice) {
            final double total = invoice['total'] as double;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.receipt_long),
                ),
                title: Text(
                  invoice['invoiceNumber'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  invoice['clientName'].isEmpty
                      ? 'No client name'
                      : invoice['clientName'],
                ),
                trailing: Text(
                  '£${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// INVOICE ITEM
// ============================================================

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

// ============================================================
// NEW INVOICE
// ============================================================

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
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    Navigator.pop(
      context,
      {
        'invoiceNumber': invoiceNumber,
        'clientName': clientController.text.trim(),
        'email': emailController.text.trim(),
        'jobNumber': jobNumberController.text.trim(),
        'total': total,
      },
    );
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Invoice details',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // CLIENT
          TextField(
            controller: clientController,
            decoration: fieldDecoration('Client name'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: fieldDecoration('Client email'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: jobNumberController,
            decoration: fieldDecoration('Order / Job Number'),
          ),

          const SizedBox(height: 30),

          // ITEMS HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              OutlinedButton.icon(
                onPressed: addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ITEM CARDS
          ...items.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final item = entry.value;

              return _itemCard(index, item);
            },
          ),

          const SizedBox(height: 20),

          // VAT
          DropdownButtonFormField<double>(
            value: vatRate,
            decoration: fieldDecoration('VAT rate'),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('0% VAT'),
              ),
              DropdownMenuItem(
                value: 5,
                child: Text('5% VAT'),
              ),
              DropdownMenuItem(
                value: 20,
                child: Text('20% VAT'),
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

          const SizedBox(height: 25),

          // TOTALS
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _summaryRow('Subtotal', subtotal),

                  const SizedBox(height: 10),

                  _summaryRow(
                    'VAT (${vatRate.toStringAsFixed(0)}%)',
                    vat,
                  ),

                  const Divider(height: 25),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '£${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: saveInvoice,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                'Save Invoice',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _itemCard(int index, InvoiceItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
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

            const SizedBox(height: 12),

            TextField(
              controller: item.descriptionController,
              decoration: fieldDecoration('Description'),
              onChanged: (_) => setState(() {}),
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
                    decoration: fieldDecoration('Quantity'),
                    onChanged: (_) => setState(() {}),
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
                    decoration: fieldDecoration('Unit price (£)'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Item total: £${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          '£${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}