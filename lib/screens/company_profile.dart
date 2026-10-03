import 'package:flutter/material.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  double vatRate = 20.0;

  @override
  void dispose() {
    companyNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Company profile saved'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Your business details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'These details will be used on your invoices.',
          ),

          const SizedBox(height: 24),

          TextField(
            controller: companyNameController,
            decoration: const InputDecoration(
              labelText: 'Company / Business Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Business Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),

          const SizedBox(height: 24),

          DropdownButtonFormField<double>(
            initialValue: vatRate,
            decoration: const InputDecoration(
              labelText: 'Default VAT Rate',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.percent),
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

          const SizedBox(height: 30),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: saveProfile,
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Company Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}