// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResponseModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) {
  return ResponseModel(
      json['code'] as int,
      json['result'] as String,
      json['data'],
      json['success'] as String,
      json['cursor'] == null
          ? null
          : Curssor.fromJson(json['cursor'] as Map<String, dynamic>),
      (json['errors'] as List)
          ?.map((e) =>
              e == null ? null : Error.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'cursor': instance.cursor,
      'errors': instance.errors
    };

Curssor _$CurssorFromJson(Map<String, dynamic> json) {
  return Curssor(
      json['total'] as int, json['offset'] as int, json['limit'] as int);
}

Map<String, dynamic> _$CurssorToJson(Curssor instance) => <String, dynamic>{
      'total': instance.total,
      'offset': instance.offset,
      'limit': instance.limit
    };

Error _$ErrorFromJson(Map<String, dynamic> json) {
  return Error(json['code'] as int, json['message'] as String);
}

Map<String, dynamic> _$ErrorToJson(Error instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
