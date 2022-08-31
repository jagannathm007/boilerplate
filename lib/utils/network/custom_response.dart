class CustomResponse {
  dynamic message;
  dynamic isSuccess;
  dynamic data;

  CustomResponse({required this.message, required this.isSuccess, this.data});

  factory CustomResponse.fromJson(Map<String, dynamic> json) {
    return CustomResponse(
      message: json['Message'] as dynamic,
      isSuccess: json['IsSuccess'] as dynamic,
      data: json['Data'] as dynamic,
    );
  }
}
