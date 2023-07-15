import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gunting_batu_kertas/src/constants/image_path.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late StreamController<int> _timeController;
  late Sink<int> _timeSink;
  late Timer _timer;
  int _time = 5;
  final _random = Random();

  String _pilihanPemain = "";
  String _pilihanMusuh = "";
  static const String gunting = "Gunting";
  static const String batu = "Batu";
  static const String kertas = "Kertas";

  @override
  void initState() {
    _timeController = StreamController();
    _timeSink = _timeController.sink..add(_time);

    _pilihJawabanAcak();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeSink.add(_time);
      if (timer.tick < 6) {
        _time--;
      }

      if (timer.tick == 6) {
        timer.cancel();
        Future.delayed(const Duration(seconds: 4)).then(
          (value) => showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => Dialog(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      _ucapanHasilPertandingan(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) {
                              return const GamePage();
                            },
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Main Ulang"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  String _ucapanHasilPertandingan() {
    if (_pilihanPemain == scissor && _pilihanMusuh == paper) {
      return "Kamu Menang";
    } else if (_pilihanPemain == scissor && _pilihanMusuh == rock) {
      return "Kamu Kalah";
    } else if (_pilihanPemain == rock && _pilihanMusuh == scissor) {
      return "Kamu Menang";
    } else if (_pilihanPemain == rock && _pilihanMusuh == paper) {
      return "Kamu Kalah";
    } else if (_pilihanPemain == paper && _pilihanMusuh == rock) {
      return "Kamu Menang";
    } else if (_pilihanPemain == paper && _pilihanMusuh == scissor) {
      return "Kamu Kalah";
    } else {
      return "Seri";
    }
  }

  void _ubahPilihan(String pilihanPemain) {
    _pilihanPemain = pilihanPemain;
    _pilihJawabanPemain(pilihanPemain);
    setState(() {});
  }

  void _pilihJawabanPemain(String pilihanPemain) {
    switch (pilihanPemain) {
      case scissor:
        _pilihanPemain = scissor;
      case rock:
        _pilihanPemain = rock;
      case paper:
        _pilihanPemain = paper;
      default:
        _pilihanPemain = paper;
    }
  }

  void _pilihJawabanAcak() async {
    final randomIntMusuh = _random.nextInt(3);
    switch (randomIntMusuh) {
      case 0:
        _pilihanMusuh = scissor;
      case 1:
        _pilihanMusuh = rock;
      case 2:
        _pilihanMusuh = paper;
      default:
        _pilihanMusuh = paper;
    }

    await Future.delayed(Duration(seconds: _time));

    if (_pilihanPemain == "") {
      final randomIntPemain = _random.nextInt(3);
      switch (randomIntPemain) {
        case 0:
          _pilihanPemain = scissor;
        case 1:
          _pilihanPemain = rock;
        case 2:
          _pilihanPemain = paper;
        default:
          _pilihanPemain = paper;
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _timeController.stream,
          builder: (context, snapshot) {
            return Stack(
              children: [
                AnimatedSwitcher(
                  switchInCurve: Curves.elasticIn,
                  switchOutCurve: Curves.elasticInOut,
                  duration: const Duration(seconds: 2),
                  child: snapshot.data == 0
                      ? Center(
                          child: Column(
                            children: [
                              Flexible(
                                child: Transform.rotate(
                                  angle: pi / 1,
                                  child: Image.asset(_pilihanMusuh),
                                ),
                              ),
                              Flexible(
                                child: Image.asset(_pilihanPemain),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
                snapshot.data != 0
                    ? Align(
                        alignment: const Alignment(0, 0.9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _pilihanPemain == scissor
                                  ? null
                                  : () {
                                      _ubahPilihan(scissor);
                                    },
                              child: const Text(gunting),
                            ),
                            ElevatedButton(
                              onPressed: _pilihanPemain == rock
                                  ? null
                                  : () {
                                      _ubahPilihan(rock);
                                    },
                              child: const Text(batu),
                            ),
                            ElevatedButton(
                              onPressed: _pilihanPemain == paper
                                  ? null
                                  : () {
                                      _ubahPilihan(paper);
                                    },
                              child: const Text(kertas),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                snapshot.data != 0
                    ? Center(
                        child: Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
