// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MediaRepository {
//   final String _baseUrl = 'https://stiff-keslie-a7medbibars-f69765cc.koyeb.app'; // Replace with your backend URL
//   late String imagePath;
//   late String mediaType;
//   late String videoPath;
//
//   final ImagePicker _picker = ImagePicker();
//
//   // Function to capture an image from the camera and send it to the backend
//   Future<void> captureImageFromCamera() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       imagePath = image.path;
//       mediaType = 'image';
//       await uploadFile(File(imagePath), mediaType);
//     }
//   }
//
//   // Function to capture a video from the camera and send it to the backend
//   Future<void> captureVideoFromCamera() async {
//     final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
//     if (video != null) {
//       videoPath = video.path;
//       mediaType = "video";
//       await uploadFile(File(videoPath), mediaType);
//     }
//   }
//
//   // Function to upload an image from the gallery and send it to the backend
//   Future<void> uploadImageFromGallery() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       imagePath = image.path;
//       mediaType = "image";
//       await uploadFile(File(imagePath), mediaType);
//     }
//   }
//
//   // Function to upload a video from the gallery and send it to the backend
//   Future<void> uploadVideoFromGallery() async {
//     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       videoPath = video.path;
//       mediaType = "video";
//       await uploadFile(File(videoPath), mediaType);
//     }
//   }
//
//   // Helper function to upload a file to the backend
//   Future<String> uploadFile(File file, String type) async {
//     final SharedPreferences prefsToken = await SharedPreferences.getInstance();
//     String token = prefsToken.getString("token") ?? '';
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$_baseUrl/media/upload'),
//     );
//     request.headers['token'] = token;
//     request.fields['type'] = type;
//     request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//     final response = await request.send();
//
//     if (response.statusCode == 201) {
//       final responseJson = await response.stream.bytesToString();
//       final Map<String, dynamic> responseData = jsonDecode(responseJson);
//       return responseData['description'];
//     } else {
//       throw Exception('Failed to upload media');
//     }
//   }
//
//   // Function to analyze media and return the description
//   Future<String> analyseMedia(File file) async {
//     final SharedPreferences prefsToken = await SharedPreferences.getInstance();
//     String token = prefsToken.getString("token") ?? '';
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$_baseUrl/media/analyze'), // Adjust the endpoint as needed
//     );
//     request.headers['token'] = token;
//     request.fields['type'] = file.path.endsWith('.mp4') ? 'video' : 'image';
//     request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//     final response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseJson = await response.stream.bytesToString();
//       final Map<String, dynamic> responseData = jsonDecode(responseJson);
//       return responseData['description'];
//     } else {
//       throw Exception('Failed to analyze media');
//     }
//   }
// }