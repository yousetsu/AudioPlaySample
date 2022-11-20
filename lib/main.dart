import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';//ファイル選択のため
import 'dart:io';//ファイル選択のため
import 'package:just_audio/just_audio.dart';//音楽再生のため
import 'package:audio_session/audio_session.dart';//音楽再生のため

/*------------------------------------------------------------------
変数定義
 -------------------------------------------------------------------*/
late AudioPlayer _player;
String strSePath = '';
//
/*------------------------------------------------------------------
メイン処理
 -------------------------------------------------------------------*/
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Select Play Stop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Audio Select Play Stop'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  //音楽ファイル選択メソッドを呼びだす
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("音楽ファイル選択・再生・停止"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:() async {
                musicFileSelect();
              },
              child: const Text("音楽ファイルを選択"),
            ),
            ElevatedButton(
               onPressed:() async {
                playMusic();
              },
              child: const Text("音楽ファイルを再生"),
            ),
            ElevatedButton(
              onPressed:() async {
                stopMusic();
              },
              child: const Text("音楽ファイルを停止"),
            ),
            const Padding(padding: EdgeInsets.all(10.0),),
            const Text("選択した音楽ファイル"),
            Text(strSePath),
          ],
        ),
      ),
    );
  }
  /*------------------------------------------------------------------
音楽ファイル選択メソッド
 -------------------------------------------------------------------*/
  void musicFileSelect() async {
    FilePickerResult? result;
    result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Please Play Music File', type: FileType.audio
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() => {
        strSePath = file.path.toString()
      });
    }
  }
/*------------------------------------------------------------------
音楽ファイル再生メソッド
 -------------------------------------------------------------------*/
  void playMusic() async{
    _player = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await _player.setLoopMode(LoopMode.all);
    if( strSePath != "") {
      await _player.setFilePath(strSePath);
    }
    await _player.play();
  }
/*------------------------------------------------------------------
音楽ファイル停止メソッド
 -------------------------------------------------------------------*/
  void stopMusic() async{
    _player.stop();
  }
}
