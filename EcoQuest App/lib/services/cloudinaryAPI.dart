import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';


// returns the URL of the stored image if successful
Future<String> uploadProfileImageToCloudinary(XFile image) async {
  return await uploadImageToCloudinary(image, "profileImageUpload");
}

Future<String> uploadQuestImageToCloudinary(XFile image) async {
  return await uploadImageToCloudinary(image, "questImageUpload");
}

Future<String> uploadImageToCloudinary(XFile image, String uploadPreset) async {
  final file = File(image.path);
  final mimeType = lookupMimeType(file.path);

  final cloudName = 'dadfbv0m6';

  final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    ));

  final response = await request.send();

  if (response.statusCode == 200) {
    final res = await http.Response.fromStream(response);
    final data = jsonDecode(res.body);
    return data['secure_url'];
  }
  return "";
}