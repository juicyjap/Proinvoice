import 'package:flutter/material.dart';

class InvoiceTemplatesPage extends StatefulWidget {
  const InvoiceTemplatesPage({super.key});

  @override
  State<InvoiceTemplatesPage> createState() => _InvoiceTemplatesPageState();
}

class _InvoiceTemplatesPageState extends State<InvoiceTemplatesPage> {
  String selectedTemplate = 'Modern';

  final List<Map<String, dynamic>> templates = [
    {
      'name': 'Modern',
      'icon': Icons.auto_awesome,
      'description': 'Clean and modern layout',
    },
    {
      'name': 'Corporate',
      'icon': Icons.business_center,
      'description': 'Professional business layout',
    },
    {
      'name': 'Minimal',
      'icon': Icons.crop_square,
      'description': 'Simple and uncluttered layout',
    },
  ];

  void selectTemplate(String name) {
    setState(() {
      selectedTemplate = name;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name template selected'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Templates'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose your invoice style',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a template to use when creating your invoices.',
          ),
          const SizedBox(height: 24),

          ...templates.map(
            (template) {
              final name = template['name'] as String;
              final isSelected = name == selectedTemplate;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => selectTemplate(name),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PROINVOICE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const Text('INVOICE'),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 8,
                                        width: double.infinity,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 8,
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 35,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              height: 35,
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          height: 10,
                                          width: 80,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Icon(
                              template['icon'] as IconData,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    template['description'] as String,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$selectedTemplate template selected',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Use Selected Template'),
          ),
        ],
      ),
    );
  }
}
