import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PostStorage {
  final String _cloudName = "dd6afzaus";
  final _apiKey = "238272859496916";
  final String _apiSecret = "R4QqSyKdJC_WjmRw4As_lTCO0Uo";

  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary({required File imageFile}) async {
    try {
      final String cloudName = _cloudName;
      const uploadPreset = 'feeds-pictures';
      final String uploadUrl =
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(resStr);
        return jsonResponse['secure_url'] as String;
      }
    } catch (e) {
      print("Error saving images:$e");
      return null;
    }
    return null;
  }

  //delete image

  /// Deletes an image from Cloudinary using its public_id
  Future<void> destroyCloudinaryImage(String publicId) async {
    final cloudName = _cloudName;
    final auth = base64Encode(utf8.encode('$_apiKey:$_apiSecret'));
    final basicAuth = 'Basic $auth';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/destroy',
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'public_id': publicId},
    );

    if (response.statusCode == 200) {
      print(' Cloudinary destroy result: ${response.body}');
    } else {
      print(
        ' Failed to destroy image: ${response.statusCode} ${response.body}',
      );
    }
  }

  //extract the public id
  String extractPublicIdFromUrl(String imageUrl) {
    try {
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;

      // Find the index of "upload"
      final uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 1 >= segments.length) {
        throw Exception('Invalid Cloudinary URL');
      }

      // Get path after /upload/, skip version like v12345678
      final publicIdParts = segments.sublist(uploadIndex + 2);
      String publicIdWithExtension = publicIdParts.join('/');

      // Remove file extension
      return publicIdWithExtension.replaceAll(RegExp(r'\.\w+$'), '');
    } catch (e) {
      print('Failed to extract public_id: $e');
      return '';
    }
  }
}
