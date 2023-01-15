class Failure {
  final String message;
  final Object? errorObject;

  Failure(this.message,{this.errorObject});

  @override
  String toString() => message;
}
