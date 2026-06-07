import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();

    return File("${dir.path}/$fileName");
  }

  static Future<void> saveJson(
    String fileName,
    List<Map<String, dynamic>> data,
  ) async {
    final file = await _getFile(fileName);

    await file.writeAsString(jsonEncode(data));
  }

  static Future<List<dynamic>> readJson(String fileName) async {
    try {
      final file = await _getFile(fileName);

      final content = await file.readAsString();

      return jsonDecode(content);
    } catch (_) {
      return [];
    }
  }
}
