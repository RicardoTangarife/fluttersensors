import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
//import 'package:login/ui/models/user.model.dart';
//import 'package:login/ui/helpers/send_email_api.dart';

class MicrophonePage extends StatefulWidget {
  const MicrophonePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MicrophonePage> createState() => _MicrophonePageState();
}

class _MicrophonePageState extends State<MicrophonePage> {
  final audioPlayer = AudioPlayer();
  //User? user = FirebaseAuth.instance.currentUser;
  String statusText = "";
  bool isComplete = false;
  bool isRecording = false;
  String? recordFilePath;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void initPlayer() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() {
        position = newPosition;
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future setAudio() async {
    //audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    //String url = _audioFile!.toString();
    audioPlayer.setUrl(recordFilePath!, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      initPlayer();
    }
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Audio Recording and Playing'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                size: 80,
              ),
              onPressed: () async {
                if (isRecording) {
                  stopRecord();
                } else {
                  startRecord();
                }
              },
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);

                await audioPlayer.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(position),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    formatTime(duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.resume();
                      }
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 50,
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    onPressed: () async {
                      //_onFileUploadButtonPressed();
                    },
                    icon: const Icon(Icons.upload),
                    iconSize: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      isRecording = true;
      RecordMp3.instance.start(recordFilePath!, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No microphone permission'),
        ),
      );
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      isRecording = false;
      setAudio();
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  int i = 0;
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  /*Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("records/${widget.user!.uid}/" + DateTime.now().toString());

    UploadTask uploadTask = ref.putFile(File(recordFilePath!));
    print(recordFilePath);
    try {
      await uploadTask;
      //widget.onUploadComplete();
      var dowurl = await ref.getDownloadURL();
      var url = dowurl.toString();
      sendEmail(url, widget.contacts, widget.loogedInUser);
      print(url);
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      //setState(() {});
    }
  }*/
}
