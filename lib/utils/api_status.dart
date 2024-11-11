class Success {
  int code;
  Object response;
  Object? count;
  Success({required this.code, required this.response, this.count});
}

class Failure {
  int code;
  Object errorResponse;
  Failure({required this.code, required this.errorResponse});
}

class ApiError {
  int code;
  Object message;
  ApiError({required this.code, required this.message});
}