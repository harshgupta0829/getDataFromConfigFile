import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileReadDemo(),
    );
  }
}

class FileReadDemo extends StatefulWidget {
  @override
  _FileReadDemoState createState() => _FileReadDemoState();
}

class _FileReadDemoState extends State<FileReadDemo> {
  Map<String, dynamic> fileContent = {"baseUrl": "Loading..."};
  final String fileName = "sample.json";
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Proceed with file operations
      createFileWithContent();
      readFile();
    } else {
      // Handle permission denied scenario
      print("Storage permission denied");
    }
  }

  Future<String> get _localPath async {
    // Using external storage for visibility
    final directory = await getExternalStorageDirectory();
    print(
        "${directory!.path} - Print the path to debug console"); // Print the path to debug console
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<void> createFileWithContent() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        final content =
            jsonEncode({"baseUrl": "https://fakestoreapi.com/products"});
        await file.writeAsString(content);
      }
    } catch (e) {
      print("Error creating file: $e");
    }
  }

  Future<void> readFile() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        String content = await file.readAsString();
        setState(() {
          fileContent = jsonDecode(content);
          _textEditingController.text = fileContent['baseUrl'];
        });
      } else {
        setState(() {
          fileContent = {"baseUrl": "File does not exist"};
        });
      }
    } catch (e) {
      setState(() {
        fileContent = {"baseUrl": "Error loading file: $e"};
      });
    }
  }


  String res = 'Click to Hit api button ';
  getData() async {
    final file = await _localFile;

    if (await file.exists()) {
      String baseUrl = await file.readAsString();
      setState(() {
        fileContent = jsonDecode(baseUrl);
        _textEditingController.text = fileContent['baseUrl'];
      });
    }
    String url = "https://fakestoreapi.com/products";
    var response = await http.get(Uri.parse(url));
    setState(() {
      var data = json.decode(response.body);
      res = data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read File Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(fileContent['baseUrl'] ?? 'Loading...'),
            Text(res),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await readFile();
              },
              child: const Text('Refresh Content'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getData();
              },
              child: const Text('Hit Api Test'),
            ),
          
          ],
        ),
      ),
    );
  }
}
