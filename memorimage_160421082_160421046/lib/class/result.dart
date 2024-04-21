class Result {
  int score;

  Result({
    required this.score,
  });

  void updateScore(int value) {
    score = value;
  }

  @override
  String toString() {
    return 'Result{Your Score: $score}';
  }
}
