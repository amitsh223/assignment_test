import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class Record_audio_screen extends StatefulWidget {
  const Record_audio_screen({super.key});

  @override
  State<Record_audio_screen> createState() => _Record_audio_screenState();
}

class _Record_audio_screenState extends State<Record_audio_screen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();
  final maxDuration = Duration(seconds: 15);
  bool isRecorderReady = false;
  bool isplaying = false;
  Duration duration = Duration.zero;
  Duration posiotion = Duration.zero;
  String? pathh;
  Timer? recordingTimer;
  Future record() async {
    if (!isRecorderReady) return;
    pathh=null;
    recordingTimer = Timer(Duration(seconds: 16), () {
      Fluttertoast.showToast(msg: "You can record upto 15 sec");
      stop();
    });
    return await recorder.startRecorder(toFile: 'audios');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    pathh = audioFile.path;
    recordingTimer?.cancel();
  }

  void initrecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
    isRecorderReady = true;
  }

  @override
  void initState() {
    initrecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Record you audio and play")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                return Text('${duration.inSeconds.remainder(60)}');
              }),
         const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
              child: Icon(
                recorder.isRecording != true ? Icons.mic : Icons.stop,
              ),
            ),
          ),
          SizedBox(
            height: size.height * .1,
          ),
          pathh != null
              ? ElevatedButton(
                  child: const Text("Play"),
                  onPressed: () {
                    audioPlayer.setFilePath(pathh!);
                    setState(() {
                      audioPlayer.play();
                    });
                  })
              : Container()
        ],
      ),
    );
  }
}
