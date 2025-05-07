import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaRepository {
  final String _baseUrl = 'https://stiff-keslie-a7medbibars-f69765cc.koyeb.app'; // Replace with your backend URL
  late String imagePath;
  late String mediaType;
  late String videoPath;


  // Function to capture an image and send it to the backend
  Future<void> captureAndSendImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath = image.path;
      mediaType = 'image';
      await uploadFile(File(imagePath), mediaType);
    }
  }

  // Function to upload an image from the gallery and send it to the backend
  Future<void> uploadImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath = image.path;
      mediaType = "image";
      await uploadFile(File(imagePath), mediaType);
    }
  }

  // Function to capture a video and send it to the backend
  Future<void> captureAndSendVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      videoPath = video.path;
      mediaType = "video";
      await uploadFile(File(videoPath), mediaType);
    }
  }

  // Function to upload a video from the gallery and send it to the backend
  Future<void> uploadVideoFromGallery() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      videoPath = video.path;
      mediaType = "video";
      await uploadFile(File(videoPath), mediaType);
    }
  }

  // Helper function to upload a file to the backend
  Future<void> uploadFile(File file, String type) async {
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String token = prefsToken.getString("token").toString();
    final response = await http.post(
      Uri.parse('$_baseUrl/media/upload'),
      headers: {'Content-Type': 'application/json',
        'token': token
      },
      body: jsonEncode({
        'file': file,
        'type': type
      }),
    );
    print(response);
    if (response.statusCode != 201) {
      throw Exception('Failed to upload media');
    }
  }
}
