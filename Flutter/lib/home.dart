import "dart:io";
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:heart_disease_prediction/auth_controller.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File? audioFile;
  String? _filePath;
  String? predicted;
  String prediction='';
  int flag=0;
  int flag1=0;

  final audioPlayer=AudioPlayer();
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;

  final audioPlayer1=AudioPlayer();
  bool isPlaying1=false;
  Duration duration1=Duration.zero;
  Duration position1=Duration.zero;

  @override
  void initState(){
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state==PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration=newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;
      });
    });
    audioPlayer1.onPlayerStateChanged.listen((state1) {
      setState(() {
        isPlaying1=state1==PlayerState.playing;
      });
    });
    audioPlayer1.onDurationChanged.listen((newDuration1) {
      setState(() {
        duration1=newDuration1;
      });
    });
    audioPlayer1.onPositionChanged.listen((newPosition1) {
      setState(() {
        position1=newPosition1;
      });
    });
  }

  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Future<void> uploadAudio(File audioFile) async {
    // final url = 'http://10.0.2.2:5000/predict';
    final url = 'http://16.171.12.47/predict';
    var request = await http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('audio_file', audioFile.path));
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    setState(() {
      prediction = responseData;
    });
    debugPrint(responseData);
  }
  Future<void> pickFile() async {
    FilePickerResult? result=await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if(result!=null){
      PlatformFile file=result.files.first;
      setState(() {
        _filePath=file.path;
        flag1=1;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictor'),
        backgroundColor: Color(0xff4c505b),
      ),
    body: Container(
      decoration: const BoxDecoration(
      image: DecorationImage(
      image: AssetImage('assets/welcome.jpeg'), fit:BoxFit.cover)),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              ElevatedButton(
                child: Text('Pick File'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4c505b),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ), onPressed: pickFile,
              ),
              SizedBox(height: 10,),
              _filePath != null
                  ? Text('Selected file: $_filePath')
                  : Text('No file selected'),
              SizedBox(height: 10,),
              flag1==1?Column(
                children: [
                  Slider(
                    activeColor: Color(0xff4c505b),
                    inactiveColor: Colors.grey,
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position=Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text(formatTime(position)),
                          Text(formatTime(duration)),
                        ]
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xff4c505b),
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause:Icons.play_arrow,
                      ),
                      iconSize: 50,
                      onPressed: () async {
                        if(isPlaying){
                          await audioPlayer.pause();
                        }else{
                          File audioFile=File(_filePath??"");
                          await audioPlayer.play(UrlSource(audioFile.path));
                        }
                      },
                    ),
                  ),
                ],
              ):Text(''),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: ()async{
                await uploadAudio(File(_filePath??""));
                flag=1;
              }, child: Text('Predict'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4c505b),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              SizedBox(height: 10,),
              prediction!=''?Text('Prediction : $prediction'):Text(''),
              SizedBox(height: 10,),
              flag==1?Column(
                children: [
                  Slider(
                    activeColor: Color(0xff4c505b),
                    inactiveColor: Color(0xff4c505b),
                    min: 0,
                    max: duration1.inSeconds.toDouble(),
                    value: position1.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position1=Duration(seconds: value.toInt());
                      await audioPlayer1.seek(position1);
                      await audioPlayer1.resume();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text(formatTime(position1)),
                          Text(formatTime(duration1)),
                        ]
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xff4c505b),
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying1 ? Icons.pause:Icons.play_arrow,
                      ),
                      iconSize: 50,
                      onPressed: () async {
                        if(isPlaying1){
                          await audioPlayer1.pause();
                        }else{
                          await audioPlayer1.play(AssetSource('$prediction.wav'));
                        }
                      },
                    ),
                  ),
                ],
              ):Text(''),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('Features'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4c505b),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ), onPressed: _filePath != null
                  ? (){
                Navigator.pushNamed(context, 'features', arguments: _filePath);
              }
                  :null,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4c505b),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ), onPressed: (){
                AuthController.instance.logOut();
                print('Logout');
              },
              ),
            ],
          ),
        ),
      )
    )
    );
  }
}