class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  bool get isUnauthorized => statusCode == 401 || statusCode == 403;

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException()
    : super(-1, 'Unable to reach the server. Please check your connection.');
}

class TimeoutException extends ApiException {
  const TimeoutException()
    : super(-1, 'The request timed out. Please try again.');
}

class ParseException extends ApiException {
  const ParseException()
    : super(-1, 'Something went wrong while reading the server response.');
}
