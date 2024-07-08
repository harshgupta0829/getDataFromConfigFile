// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FileReadDemo(),
//     );
//   }
// }

// class FileReadDemo extends StatefulWidget {
//   @override
//   _FileReadDemoState createState() => _FileReadDemoState();
// }

// class _FileReadDemoState extends State<FileReadDemo> {
//   String fileContent = "Loading...";
//   final String fileName = "sample.txt";
//   TextEditingController _textEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }

//   Future<void> requestPermissions() async {
//     if (await Permission.storage.request().isGranted) {
//       // Proceed with file operations
//       createFileWithContent();
//       readFile();
//     } else {
//       // Handle permission denied scenario
//       print("Storage permission denied");
//     }
//   }

//   Future<String> get _localPath async {
//     // Using external storage for visibility
//     final directory = await getExternalStorageDirectory();
//     print(
//         "${directory!.path} - Print the path to debug console"); // Print the path to debug console
//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/$fileName');
//   }

//   Future<void> createFileWithContent() async {
//     try {
//       final file = await _localFile;

//       if (!await file.exists()) {
//         await file.writeAsString("Hello World");
//       }
//     } catch (e) {
//       print("Error creating file: $e");
//     }
//   }

//   Future<void> readFile() async {
//     try {
//       final file = await _localFile;

//       if (await file.exists()) {
//         String content = await file.readAsString();
//         setState(() {
//           fileContent = content;
//           _textEditingController.text = content;
//         });
//       } else {
//         setState(() {
//           fileContent = "File does not exist";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         fileContent = "Error loading file: $e";
//       });
//     }
//   }

//   Future<void> editFile(String newContent) async {
//     try {
//       final file = await _localFile;
//       if (await file.exists()) {
//         await file.writeAsString(newContent);
//         readFile(); // Refresh the content displayed
//       } else {
//         print("File does not exist");
//       }
//     } catch (e) {
//       print("Error editing file: $e");
//     }
//   }

//   Future<void> openFile() async {
//     try {
//       final file = await _localFile;
//       print('File path: ${file.path}'); // Debugging: Print file path
//       if (await file.exists()) {
//         final result = await OpenFile.open(file.path);
//         print(result.message); // Debugging: Print result message
//       } else {
//         print("File does not exist");
//       }
//     } catch (e) {
//       print("Error opening file: $e");
//     }
//   }

//   void showEditDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit File Content'),
//           content: TextField(
//             controller: _textEditingController,
//             maxLines: null,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Edit File Content',
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await editFile(_textEditingController.text);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Read File Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(fileContent),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await readFile();
//               },
//               child: const Text('Refresh Content'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await openFile();
//               },
//               child: const Text('Open File'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showEditDialog();
//               },
//               child: const Text('Edit File'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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

  // Future<void> editFile(String baseUrl) async {
  //   try {
  //     final file = await _localFile;
  //     if (await file.exists()) {
  //       final content = jsonEncode({"baseUrl": baseUrl});
  //       await file.writeAsString(content);
  //       readFile(); // Refresh the content displayed
  //     } else {
  //       print("File does not exist");
  //     }
  //   } catch (e) {
  //     print("Error editing file: $e");
  //   }
  // }

  // Future<void> openFile() async {
  //   try {
  //     final file = await _localFile;
  //     print('File path: ${file.path}'); // Debugging: Print file path
  //     if (await file.exists()) {
  //       final result = await OpenFile.open(file.path);
  //       print(result.message); // Debugging: Print result message
  //     } else {
  //       print("File does not exist");
  //     }
  //   } catch (e) {
  //     print("Error opening file: $e");
  //   }
  // }

  // void showEditDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Edit File Content'),
  //         content: TextField(
  //           controller: _textEditingController,
  //           maxLines: null,
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(),
  //             labelText: 'Edit File Content',
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               await editFile(_textEditingController.text);
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
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
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     await openFile();
            //   },
            //   child: const Text('Open File'),
            // ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     showEditDialog();
            //   },
            //   child: Text('Edit File'),
            // ),
          ],
        ),
      ),
    );
  }
}
