class ServerResponse {
  ServerResponse({
    required this.statusCode,
    required this.body,
  });
  late final int statusCode;
  late final Map body;

  ServerResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    body = json['body'];
  }
}
