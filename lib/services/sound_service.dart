import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService extends ChangeNotifier {
  static const String _enableSoundsKey = 'enableSounds';

  bool _enableSounds = true;

  bool get enableSounds => _enableSounds;

  bool _preferencesLoaded = false;

  bool get preferencesLoaded => _preferencesLoaded;

  final Map<String, AudioPlayer> _audioCache = {};

  SoundService() {
    _loadPreferences();
    _preloadSounds();
  }

  set enableSounds(bool value) {
    if (_enableSounds != value) {
      _enableSounds = value;
      _saveBoolPreference(_enableSoundsKey, value);
      notifyListeners();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _enableSounds = prefs.getBool(_enableSoundsKey) ?? true;
    _preferencesLoaded = true;
    notifyListeners();
  }

  Future<void> _saveBoolPreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _preloadSounds() async {
    await _loadAndCache('toggle_sound.mp3');
    await _loadAndCache('tap_sound.mp3');
    await _loadAndCache('result_sound.mp3');
    await _loadAndCache('clear_sound.mp3');
    await _loadAndCache('slide_sound.mp3');
    await _loadAndCache('about_sound.mp3');
    await _loadAndCache('flip_sound.wav');
  }

  Future<void> _loadAndCache(String fileName) async {
    final player = AudioPlayer();
    try {
      await player.setAsset('assets/sounds/$fileName');
      _audioCache[fileName] = player;
    } catch (e) {
      if (kDebugMode) print('Failed to preload $fileName: $e');
    }
  }

  Future<void> _play(String fileName) async {
    if (!_enableSounds) return;

    final player = _audioCache[fileName];
    if (player != null) {
      try {
        await player.stop();
        await player.seek(Duration.zero);
        await player.play();
      } catch (e) {
        if (kDebugMode) print('Error playing $fileName: $e');
      }
    } else {
      if (kDebugMode) print('Sound not cached: $fileName');
    }
  }

  Future<void> playTapSound() => _play('tap_sound.mp3');

  Future<void> playToggleSound() => _play('toggle_sound.mp3');

  Future<void> playResultSound() => _play('result_sound.mp3');

  Future<void> playResetSound() => _play('clear_sound.mp3');

  Future<void> playSlideSound() => _play('slide_sound.mp3');

  Future<void> playAboutSound() => _play('about_sound.mp3');

  Future<void> playFlipSound() => _play('flip_sound.wav');

  @override
  void dispose() {
    for (var player in _audioCache.values) {
      player.dispose();
    }
    super.dispose();
  }
}
