import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration? duration;
  Timer? timer;

  @override
  void initState() {
    audioPlayer.setAsset('assets/mobb.mp3').then((value) {
      debugPrint(value.toString());
      duration = value;
      audioPlayer.play();
      timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {});
      });
      setState(() {});
    }).catchError((err) {
      debugPrint(err);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('assets/cover.jpg'),
                        fit: BoxFit.cover)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/ufo.png'),
                      const SizedBox(
                        width: 16,
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UFO',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '@UFO-Alien',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.heart,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        'assets/cover.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      'EYE FOR AN EYE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      'MOBB DEEP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (duration != null)
                    Slider(
                        inactiveColor: Colors.white12,
                        activeColor: Colors.white,
                        max: duration!.inMilliseconds.toDouble(),
                        value: audioPlayer.position.inMilliseconds.toDouble(),
                        onChangeStart: (value) {
                          audioPlayer.pause();
                        },
                        onChangeEnd: (value) {
                          audioPlayer.play();
                        },
                        onChanged: (value) {
                          audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        }),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          audioPlayer.position.toMinutesSeconds(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        if (duration != null)
                          Text(
                            duration!.toMinutesSeconds(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.backward_fill,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        iconSize: 56,
                        onPressed: () {
                          if (audioPlayer.playing) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play();
                          }
                        },
                        icon: Icon(
                          audioPlayer.playing
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.forward_fill,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension DurationExtensions on Duration {
  /// convert duration to readable string
  /// 02:20
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// 02:20:20
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  /// 20:20
  String toMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }
}
