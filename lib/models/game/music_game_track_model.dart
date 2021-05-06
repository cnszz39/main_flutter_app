import 'package:main_flutter_app/models/game/music_game_info_by_difficulty.dart';

class MusicGameTrackModel {
  final String id;
  final String trackName;
  final String source;
  final String category;
  final String imageUrl;
  final List<MusicGameInfoByDifficulty> difficultyInfos;

  MusicGameTrackModel({
    this.id,
    this.trackName,
    this.source,
    this.category,
    this.imageUrl,
    this.difficultyInfos,
  });
}
