
import 'package:course_app/data/user_dto.dart';
import 'package:course_app/data/user_info.dart';

class BeanUtil{

   static UserInfoVo_TO_UserSubDto(UserInfoVo suor,UserSubDto userSubDto){
    userSubDto.nickname=suor.nickname;
    userSubDto.faceImage=suor.faceImage;
    userSubDto.faceImageBig=suor.faceImageBig;
    userSubDto.role=suor.role;
    userSubDto.sex=suor.sex;
    userSubDto.time=suor.identityVo.time;
    userSubDto.workId=suor.identityVo.workId;
    userSubDto.schoolName=suor.identityVo.schoolName;
    userSubDto.realName=suor.identityVo.realName;
    userSubDto.stuId=suor.identityVo.stuId;
    userSubDto.classId=suor.identityVo.classId;
    return userSubDto;
  }
}