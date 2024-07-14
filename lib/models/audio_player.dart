import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioPlayerModel extends ChangeNotifier {
  String? _currentTrack;
  final _player = AudioPlayer();

  AudioPlayerModel() {
    _player.setLoopMode(LoopMode.all);
  }

  void switchOrPause(String track) async {
    if (_currentTrack != track) {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse('asset:///music/$track'),
          tag: MediaItem(
            id: track,
            title: formatFilename(track),
          ),
        ),
        initialPosition: Duration.zero,
        preload: true,
      );
      // await _player.setAsset('music/$track');
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

  void pause() async {
    await _player.pause();
    notifyListeners();
  }

  bool get isPlaying => _player.playing;
  String? get currentTrack => _currentTrack;

  static String formatFilename(String filename) {
    final name = filename.split('.')[0];
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
