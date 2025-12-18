
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {
  final String _imgbbKey = "5f3dc3a62f073d345859c434a0f64683";

  final List<String> _removeBgApiKeys = [
    "grGUzk1Hiw1RkMe4WdrpBiN3",
    "rjw4jKfNwS2SwFhKw9cCQRDb",
    "API_KEY_3",
  ];

  int _currentKeyIndex = 0;

  String get _currentKey => _removeBgApiKeys[_currentKeyIndex];

  void _switchKey() {
    if (_currentKeyIndex < _removeBgApiKeys.length - 1) {
      _currentKeyIndex++;
      print("✅ تم التبديل للمفتاح الجديد: $_currentKey");
    } else {
      print("❌ جميع المفاتيح استهلكت الحد المسموح!");
    }
  }

  Future<File> compressImage(File file) async {
    final targetPath = '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1080,
      minHeight: 1080,
    );

    if (compressedFile == null) {
      throw Exception("فشل في ضغط الصورة");
    }

    return File(compressedFile.path);
  }

  Future<File?> removeBackground(File imageFile) async {
    while (_currentKeyIndex < _removeBgApiKeys.length) {
      try {
        final uri = Uri.parse("https://api.remove.bg/v1.0/removebg");
        final request = http.MultipartRequest('POST', uri)
          ..headers['X-Api-Key'] = _currentKey
          ..files.add(await http.MultipartFile.fromPath('image_file', imageFile.path))
          ..fields['size'] = 'auto';

        final response = await request.send();

        if (response.statusCode == 200) {
          final bytes = await response.stream.toBytes();
          final outputFile = File('${imageFile.parent.path}/nobg_${imageFile.uri.pathSegments.last}');
          await outputFile.writeAsBytes(bytes);
          print("✅ تمت إزالة الخلفية بنجاح");
          return outputFile;
        } else if (response.statusCode == 429) {
          print("⚠ المفتاح $_currentKey تجاوز الحد! ننتقل للذي بعده...");
          _switchKey();
        } else {
          print("❌ remove.bg error: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        print("❌ Exception in removeBackground: $e");
        return null;
      }
    }
    print("❌ لا يوجد مفاتيح صالحة متبقية!");
    return null;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse("https://api.imgbb.com/1/upload?key=$_imgbbKey");
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(uri, body: {
        "image": base64Image,
      }).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["data"]["url"];
      } else {
        print("❌ Error uploading image: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }

  Future<String?> processAndUpload(File imageFile) async {
    try {
      final compressed = await compressImage(imageFile);
      final noBgFile = await removeBackground(compressed) ?? compressed;
      return await uploadImage(compressed);
    } catch (e) {
      print("❌ Error in processAndUpload: $e");
      return null;
    }
  }
}