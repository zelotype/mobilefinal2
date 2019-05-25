import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  FileManager._();

  static final FileManager fileManager = FileManager._();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // print(path);
    return File('$path/text.txt');
  }

  Future<File> writeFile(String counter) async {
    final file = await _localFile;
    
    // Write the file
    return file.writeAsString('$counter');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      // print(file.path);
      // Read the file
      String contents = await file.readAsString();
      
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
}