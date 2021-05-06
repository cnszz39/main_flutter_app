class MusicGameInfoByDifficulty {
  final String id;
  final int level;
  final String difficultyType;
  final DateTime lastPlayDateTime;
  final int playTimes;
  final int highScore;
  final int highTechnicalScore;

  MusicGameInfoByDifficulty({
    this.id,
    this.level,
    this.difficultyType,
    this.lastPlayDateTime,
    this.playTimes,
    this.highScore,
    this.highTechnicalScore,
  });
}
