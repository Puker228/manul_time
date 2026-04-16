/// Stub ambient audio service.
///
/// To enable real audio:
/// 1. Add `audioplayers: ^6.0.0` to pubspec.yaml
/// 2. Add sound files to assets/audio/
/// 3. Uncomment the implementation below
///
/// The interface is defined here so the rest of the app can call it
/// without any changes when the real implementation is wired in.
abstract class AudioService {
  Future<void> playAmbient();
  Future<void> stopAmbient();
  Future<void> playTick();
}

class StubAudioService implements AudioService {
  @override
  Future<void> playAmbient() async {
    // TODO: AudioPlayer().play(AssetSource('audio/ambient.mp3'), volume: 0.3);
  }

  @override
  Future<void> stopAmbient() async {
    // TODO: AudioPlayer().stop();
  }

  @override
  Future<void> playTick() async {
    // TODO: AudioPlayer().play(AssetSource('audio/tick.mp3'), volume: 0.6);
  }
}
