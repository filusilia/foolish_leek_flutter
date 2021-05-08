import 'dart:convert' show json;

class ResultResponse {
  String? apiversion;
  String? code;
  String? message;
  dynamic? data;

  ResultResponse.fromParams(
      {this.apiversion, this.code, this.message, this.data});

  factory ResultResponse(Object jsonStr) => jsonStr is String
      ? ResultResponse.fromJson(json.decode(jsonStr))
      : ResultResponse.fromJson(jsonStr);

  static ResultResponse? parse(jsonStr) =>
      ['null', '', null].contains(jsonStr) ? null : ResultResponse(jsonStr);

  ResultResponse.fromJson(jsonRes) {
    apiversion = jsonRes['apiversion'];
    code = jsonRes['code'];
    message = jsonRes['message'];
    data = jsonRes['data'];
  }

  @override
  String toString() {
    return '{"apiversion": ${apiversion != null ? '${json.encode(apiversion)}' : 'null'}, '
        '"code": ${code != null ? '${json.encode(code)}' : 'null'}, '
        '"message": ${message != null ? '${json.encode(message)}' : 'null'}, '
        '"data": ${data != null ? '${json.encode(data)}' : 'null'}}';
  }

  String toJson() => this.toString();
}

