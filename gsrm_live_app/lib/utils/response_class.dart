class ResponseClass<T> {
  final bool isSuccess;
  final T? data;
  final String errorMessage;

  ResponseClass({
    required this.isSuccess,
    required this.data,
    required this.errorMessage,
  });

  // Factory constructor to create a successful response
  factory ResponseClass.success(T data) {
    return ResponseClass(
      isSuccess: true,
      data: data,
      errorMessage: '',
    );
  }

  // Factory constructor to create an error response
  factory ResponseClass.error(String errorMessage) {
    return ResponseClass(
      isSuccess: false,
      data: null,
      errorMessage: errorMessage,
    );
  }
}
