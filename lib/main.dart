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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> invoices = [];

  void addInvoice(Map<String, dynamic> invoice) {
    setState(() {
      invoices.add(invoice);
    });
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
          ? _emptyDashboard(context)
          : _invoiceList(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final invoice = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (_) => const NewInvoicePage(),
            ),
          );

          if (invoice != null) {
            addInvoice(invoice);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
      ),
    );
  }

  Widget _emptyDashboard(BuildContext context) {
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
              'Create your first invoice',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Create professional invoices quickly and easily.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () async {
                final invoice =
                    await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewInvoicePage(),
                  ),
                );

                if (invoice != null) {
                  addInvoice(invoice);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create New Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceList(BuildContext context) {
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
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ...invoices.asMap().entries.map(
          (entry) {
            final invoice = entry.value;
            final total = invoice['total'] as double;

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

class NewInvoicePage extends StatefulWidget {
  const NewInvoicePage({super.key});

  @override
  State<NewInvoicePage> createState() => _NewInvoicePageState();
}

class _NewInvoicePageState extends State<NewInvoicePage> {
  final clientController = TextEditingController();
  final emailController = TextEditingController();
  final jobNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final priceController = TextEditingController();

  double vatRate = 20.0;

  @override
  void dispose() {
    clientController.dispose();
    emailController.dispose();
    jobNumberController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  double get subtotal {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0;
    return quantity * price;
  }

  double get vat {
    return subtotal * vatRate / 100;
  }

  double get total {
    return subtotal + vat;
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
        'description': descriptionController.text.trim(),
        'total': total,
      },
    );
  }

  InputDecoration decoration(String label) {
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

          TextField(
            controller: clientController,
            decoration: decoration('Client name'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: decoration('Client email'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: jobNumberController,
            decoration: decoration('Order / Job Number'),
          ),

          const SizedBox(height: 24),

          const Text(
            'Item',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: descriptionController,
            decoration: decoration('Description'),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: decoration('Quantity'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: decoration('Price (£)'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<double>(
            initialValue: vatRate,
            decoration: decoration('VAT rate'),
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

          const SizedBox(height: 28),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _summaryRow('Subtotal', subtotal),
                  const SizedBox(height: 10),
                  _summaryRow('VAT (${vatRate.toStringAsFixed(0)}%)', vat),
                  const Divider(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _summaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          '£${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}