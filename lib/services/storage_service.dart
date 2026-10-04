import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String companyProfileKey = 'company_profile';
  static const String clientsKey = 'clients';
  static const String savedItemsKey = 'saved_items';
  static const String invoicesKey = 'invoices';
  static const String templateKey = 'selected_template';

  static Future<void> saveCompanyProfile(
    Map<String, dynamic> profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      companyProfileKey,
      jsonEncode(profile),
    );
  }

  static Future<Map<String, dynamic>> getCompanyProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(companyProfileKey);

    if (data == null || data.isEmpty) {
      return {};
    }

    return Map<String, dynamic>.from(
      jsonDecode(data),
    );
  }

  static Future<void> saveClients(
    List<Map<String, dynamic>> clients,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      clientsKey,
      jsonEncode(clients),
    );
  }

  static Future<List<Map<String, dynamic>>> getClients() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(clientsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(data) as List;

    return decoded
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  static Future<void> saveItems(
    List<Map<String, dynamic>> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      savedItemsKey,
      jsonEncode(items),
    );
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(savedItemsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(data) as List;

    return decoded
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  static Future<void> saveInvoices(
    List<Map<String, dynamic>> invoices,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      invoicesKey,
      jsonEncode(invoices),
    );
  }

  static Future<List<Map<String, dynamic>>> getInvoices() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(invoicesKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(data) as List;

    return decoded
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }

  static Future<void> saveTemplate(String template) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      templateKey,
      template,
    );
  }

  static Future<String> getTemplate() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(templateKey) ?? 'Modern';
  }
}