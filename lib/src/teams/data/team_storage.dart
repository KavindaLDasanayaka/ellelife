import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class TeamStorage {
  final String _cloudName = "dd6afzaus";
  // Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      final String cloudName = _cloudName;
      const uploadPreset = 'teams-pictures';
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
}
