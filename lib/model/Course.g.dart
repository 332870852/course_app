// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course()
    ..courseId = json['courseId'] as num
    ..title = json['courseTitle'] as String
    ..joincode = json['code'] as String
    ..courseNumber = json['number'] as String
    ..start = json['start'] as num
    ..end = json['end'] as num
    ..semester = json['semester'] as num
    ..member = json['member'] as int
    ..bgkColor = json['bgkColor'] as String
    ..bgkUrl = json['bgkUrl'] as String
    ..teacherId = json['teacherId'] as String
    ..cid = json['cid'] as String
    ..head_urls = (json['head_urls'] as List)?.map((e) => e as String)?.toList()
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..userIdSet = (json['userIdSet'] as List)?.map((e) => e as num)?.toList();
}

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'courseTitle': instance.title,
      'code': instance.joincode,
      'number': instance.courseNumber,
      'start': instance.start,
      'end': instance.end,
      'semester': instance.semester,
      'member': instance.member,
      'bgkColor': instance.bgkColor,
      'bgkUrl': instance.bgkUrl,
      'teacherId': instance.teacherId,
      'cid': instance.cid,
      'head_urls': instance.head_urls,
      'createTime': instance.createTime?.toIso8601String(),
      'userIdSet': instance.userIdSet
    };
