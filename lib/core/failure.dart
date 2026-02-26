class Failure {
  final String message;
  final int? statusCode;

  Failure({String? message, this.statusCode})
      : message = message ?? 'Whoops! Try again';

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/**
 * var failure1 = Failure(message: "Server error", statusCode: 500);
var failure2 = Failure(statusCode: 404); // message sẽ là "Whoops! Try again"
var failure3 = Failure(); // message = "Whoops! Try again", statusCode = null

try {
  await Hive.openBox<Word>(AppHive.wordKey);
} catch (e) {
  return Failure(message: "Failed to open word box: $e");
}
 */
