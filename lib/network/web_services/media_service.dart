import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "package:path/path.dart" as path;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';



class MediaService {
  static const String baseUrl = 'https://stiff-keslie-a7medbibars-f69765cc.koyeb.app';
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login first.');
    }
    return {
      'token': token,
      'Accept': 'application/json',
    };
  }

  Future<http.Response> uploadMedia({
    required File file,
    String? title,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/media/upload'),
      );

      // Add headers
      request.headers.addAll(headers);

      // Get file extension and validate
      String fileExtension = path.extension(file.path).toLowerCase();
      print('File path: ${file.path}');
      print('File extension: $fileExtension');
      
      if (!['.jpg', '.jpeg', '.png', '.gif', '.mp4', '.mov', '.avi'].contains(fileExtension)) {
        throw Exception('Only images (jpg, jpeg, png, gif) and videos (mp4, mov, avi) are allowed.');
      }

      // Determine content type
      final contentType = fileExtension.contains('mp4') || fileExtension.contains('mov') || fileExtension.contains('avi')
          ? MediaType('video', fileExtension.substring(1))
          : MediaType('image', fileExtension.substring(1));

      // Add file
      if (kIsWeb) {
        // For web platform
        final bytes = await file.readAsBytes();
        print('Web upload - File size: ${bytes.length} bytes');

        // Generate a unique filename for web uploads
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'upload_$timestamp$fileExtension';
        
        // Create a temporary URL for the file
        final blob = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: contentType,
        );

        // Add the file to the request
        request.files.add(blob);
        
        // Add the file URL as a field
        request.fields['file_url'] = 'blob:${Uri.encodeComponent(filename)}';
      } else {
        // For mobile platforms
        print('Mobile upload - File path: ${file.path}');
        final filename = path.basename(file.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: filename,
            contentType: contentType,
          ),
        );
      }

      // Add other fields if they are not null
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;

      print('Sending request to: ${request.url}');
      print('Request headers: ${request.headers}');
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.filename).toList()}');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid file type. Only images and videos are allowed. Server response: ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: ${response.body}. Please try again or contact support.');
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload media: ${response.statusCode} - ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error during upload: $e');
      if (e.toString().contains('No authentication token found')) {
        throw Exception('Please login first to upload media.');
      }
      throw Exception('Failed to upload media: $e');
    }
  }

  Future<void> uploadMediaWeb(List<int> bytes, String filename) async {
    try {
      final headers = await _getHeaders();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/media/upload'),
      );
      request.headers.addAll(headers);
      // Determine content type from filename extension
      String fileExtension = path.extension(filename).toLowerCase();
      final contentType = fileExtension.contains('mp4') || fileExtension.contains('mov') || fileExtension.contains('avi')
          ? MediaType('video', fileExtension.substring(1))
          : MediaType('image', fileExtension.substring(1));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: contentType,
        ),
      );
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to upload media (web): ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to upload media (web): $e');
    }
  }

  Future<Map<String, dynamic>> uploadUrl(String url) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/media/upload'),
      headers: headers,
      body: {'file': url},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload URL: ${response.body}');
    }
  }
} 