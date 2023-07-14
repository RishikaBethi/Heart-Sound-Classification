import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:heart_disease_prediction/auth_controller.dart';

class MyFeatures extends StatefulWidget {
  final String? audioFilePath;

  const MyFeatures({Key? key, this.audioFilePath}) : super(key: key);

  @override
  State<MyFeatures> createState() => _MyFeaturesState();
}

class _MyFeaturesState extends State<MyFeatures> {
  String waveImagePath = '';
  String spectrogramImagePath = '';

  @override
  void initState() {
    super.initState();
    if (widget.audioFilePath != null && widget.audioFilePath!.isNotEmpty) {
      File audioFile = File(widget.audioFilePath!);
      fetchWaveImage(audioFile).then((path) {
        setState(() {
          waveImagePath = path;
        });

        fetchSpectrogramImage(audioFile).then((path) {
          setState(() {
            spectrogramImagePath = path;
          });
        });
      });
    }
  }

  Future<String> fetchWaveImage(File audioFile) async {
    // final url = 'http://10.0.2.2:5000/waveplot';
    final url = 'http://16.171.12.47/waveplot';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
        await http.MultipartFile.fromPath('audio_file', audioFile.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      // Save the wave image locally
      final bytes = await response.stream.toBytes();
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/waveform.png';
      final file = File(imagePath);
      await file.writeAsBytes(bytes);
      // Return the saved wave image path
      return imagePath;
    } else {
      throw Exception('Failed to fetch wave image');
    }
  }

  Future<String> fetchSpectrogramImage(File audioFile) async {
    // final url = 'http://10.0.2.2:5000/specplot';
    final url = 'http://16.171.12.47/specplot';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
        await http.MultipartFile.fromPath('audio_file', audioFile.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      // Save the spectrogram image locally
      final bytes = await response.stream.toBytes();
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/spectrogram.png';
      final file = File(imagePath);
      await file.writeAsBytes(bytes);
      // Return the saved spectrogram image path
      return imagePath;
    } else {
      throw Exception('Failed to fetch spectrogram image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Analysis'),
        backgroundColor: Color(0xff4c505b),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/welcome.jpeg'), fit:BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (waveImagePath.isNotEmpty)
                Column(
                  children: [
                    Text('Waveform'),
                    SizedBox(height: 10),
                    Image.file(File(waveImagePath)),
                  ],
                ),
              SizedBox(height: 40),
              if (spectrogramImagePath.isNotEmpty)
                Column(
                  children: [
                    Text('Spectrogram'),
                    SizedBox(height: 10),
                    Image.file(File(spectrogramImagePath)),
                  ],
                ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4c505b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  AuthController.instance.logOut();
                  print('Logout');
                },
              ),
            ],
          ),
      )
      ),
    );
  }
}