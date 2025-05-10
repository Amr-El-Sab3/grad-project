import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collection_model.dart';

class CollectionsService {
  final String _baseUrl = 'https://stiff-keslie-a7medbibars-f69765cc.koyeb.app';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login first.');
    }
    return {
      'Content-Type': 'application/json',
      'token': token,
    };
  }

  Future<List<Collection>> fetchCollections() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/collections'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        List<dynamic> jsonData = jsonResponse['data'];
        return jsonData.map((item) => Collection.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load collections: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load collections');
    }
  }

  Future<void> createCollection(String name) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/collections/create'),
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    print('Response status code: ${response.statusCode}'); // Debug log
    print('Response body: ${response.body}'); // Debug log

    if (response.statusCode != 201) {
      throw Exception('Failed to create collection: ${response.body}');
    }
  }

  Future<void> deleteCollection(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/collections/$id'),
      headers: headers,
    );

    print('Delete response status code: ${response.statusCode}'); // Debug log
    print('Delete response body: ${response.body}'); // Debug log

    if (response.statusCode != 200) {
      throw Exception('Failed to delete collection: ${response.body}');
    }
  }
}
