import 'package:main_flutter_app/models/game/music_game_track_model.dart';

class MusicGame {
  final String id;
  final String name;
  final List<MusicGameTrackModel> tracks;

  MusicGame({
    this.id,
    this.name,
    this.tracks,
  });
}
