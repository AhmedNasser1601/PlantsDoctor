import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  String _imageUrl = '';
  String _result = '';
  Uint8List? _imageBytes;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    Uint8List? bytes;

    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click();

      await input.onChange.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files![0]);
      await reader.onLoad.first;
      final encoded = reader.result as String;
      bytes = base64Decode(
          encoded.replaceFirst(RegExp('data:image/[^;]+;base64,'), ''));
      setState(() => _imageUrl = encoded);
    } else {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() => _imageUrl = pickedFile.path);
        final file = File(pickedFile.path);
        bytes = await file.readAsBytes();
      }
    }

    if (bytes != null) {
      setState(() {
        _imageBytes = bytes;
        _result = 'Please wait, the image is analyzing ..';
      });

      await _classifyImage();
    }
  }

  Future<void> _classifyImage() async {
    final List<String> apiKeys = [
      'kvsdLHCo355jGksdfXD9CEx9v5xe5sM56wU40xcSab0zBI7LND',
      'V4G2wLVoNCcbdctcqV0FYms4wPiPDxa7XO1ryNY0b8SHhBwl9n',
    ];

    for (final apiKey in apiKeys) {
      final response = await http.post(
        Uri.parse('https://api.plant.id/v2/identify'),
        headers: {
          'Content-Type': 'application/json',
          'Api-Key': apiKey,
        },
        body: jsonEncode({
          'organs': [
            'leaf',
            'flower',
            'fruit',
            'bark',
            'habit',
            'Root',
            'Stem',
            'Seed',
            'Inflorescence',
            'Bud',
            'other'
          ],
          'organs_threshold': 0.51,
          'language': 'en',
          'plant_details': ['common_names'],
          'images': [_imageUrl.split(',')[1]],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> suggestions = responseBody['suggestions'];
        if (suggestions.isNotEmpty) {
          final Map<String, dynamic> plantDetails =
              suggestions[0]['plant_details'];
          final List<dynamic> commonNames = plantDetails['common_names'];
          setState(() => _result = commonNames.isNotEmpty
              ? commonNames[0]
              : suggestions[0]['plant_name']);
        } else {
          setState(() => _result = 'Plant not found');
        }
        break;
      } else {
        setState(() => _result = 'Error: ${response.reasonPhrase}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Choose an image'),
            ),
            SizedBox(height: 20.0),
            if (_imageUrl.isNotEmpty)
              Image.network(
                _imageUrl,
                height: 300.0,
              ),
            SizedBox(height: 20.0),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
