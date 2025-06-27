class CancelledException implements Exception {
  @override
  String toString() => 'Operation was cancelled';
}