import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerModel extends ChangeNotifier {
  String? _currentTrack;
  final _player = AudioPlayer();

  AudioPlayerModel() {
    _player.setLoopMode(LoopMode.all);
    _player.playingStream.listen((_) => notifyListeners());
  }

  void switchOrPause(String track, int level) async {
    if (_currentTrack != track) {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///music/$track'),
          tag: MediaItem(
            id: track,
            title: formatFilename(track),
            artUri: await _getImageFileFromAssets(level),
          ),
        ),
        initialPosition: Duration.zero,
        preload: true,
      );

      _currentTrack = track;
      _player.play();
    } else {
      if (_player.playing) {
        await _player.pause();
      } else {
        _player.play();
      }
    }

    notifyListeners();
  }

  Future<Uri> _getImageFileFromAssets(int level) async {
    final fileName = 'level-$level-album-art.png';
    final byteData = await rootBundle.load('images/$fileName');
    final buffer = byteData.buffer;

    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    var filePath = '$tempPath/$fileName';

    return (await File(filePath).writeAsBytes(buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    )))
        .uri;
  }

  void pause() async {
    await _player.pause();
    notifyListeners();
  }

  void stop() async {
    await _player.stop();
    notifyListeners();
  }

  void togglePausePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      _player.play();
    }

    notifyListeners();
  }

  void seek(Duration position) async {
    await _player.seek(position);
  }

  bool get isPlaying => _player.playing;
  String? get currentTrack => _currentTrack;

  Stream<Duration> get stream => _player.positionStream;
  Duration? get duration => _player.duration;

  static String formatFilename(String filename) {
    final name = filename.split('.')[0];
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
