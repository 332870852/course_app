import 'package:json_annotation/json_annotation.dart';
part 'ResponseModel.g.dart';

@JsonSerializable()
class ResponseModel extends Object {//with $ResponseModelSerializerMixin
  int code;
  String result;
  Object data;
  String success;
  Curssor cursor;
  List<Error> errors;

  ResponseModel(this.code, this.result, this.data, this.success, this.cursor,
      this.errors);


  @override
  String toString() {
    return 'ResponseModel{code: $code, result: $result, data: $data, success: $success, cursor: $cursor, errors: $errors}';
  }

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}

@JsonSerializable()
class Curssor extends Object {// with $CurssorSerializerMixin
  int total;
  int offset;
  int limit;

  Curssor(this.total, this.offset, this.limit);


  @override
  String toString() {
    return 'Curssor{total: $total, offset: $offset, limit: $limit}';
  }

  factory Curssor.fromJson(Map<String, dynamic> json) =>
      _$CurssorFromJson(json);

  Map<String, dynamic> toJson() => _$CurssorToJson(this);
}


@JsonSerializable()
class Error extends Object {//with $ErrorSerializerMixin
  int code;
  String message;

  Error(this.code, this.message);

  @override
  String toString() {
    return 'Error{code: $code, message: $message}';
  }
  factory Error.fromJson(Map<String, dynamic> json) =>
      _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}