import 'package:flutter/material.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final List<Map<String, dynamic>> savedItems = [];

  void addItem() {
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Saved Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Default Price (£)',
                  prefixText: '£ ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final description =
                    descriptionController.text.trim();
                final price =
                    double.tryParse(priceController.text.trim()) ?? 0;

                if (description.isEmpty) {
                  return;
                }

                setState(() {
                  savedItems.add({
                    'description': description,
                    'price': price,
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int index) {
    setState(() {
      savedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: savedItems.isEmpty
          ? const Center(
              child: Text(
                'No saved items yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2),
                    ),
                    title: Text(item['description']),
                    subtitle: Text(
                      '£${(item['price'] as double).toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => deleteItem(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addItem,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}