
import 'package:common_utils/common_utils.dart';

class FileIconUtil{

  static Map<String, dynamic> fileIcon = {
    'image/jpeg': 'assets/fimage/jpg.png',
    'video/mp4': 'assets/fimage/mp4.png',
    'audio/mpeg': 'assets/fimage/music.png',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
    'assets/fimage/docx.png',
    'application/pdf': 'assets/fimage/pdf.png',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
    'assets/fimage/file.png',
    'image': 'assets/fimage/picture.png',
    'video': 'assets/fimage/video.png',
    'file': 'assets/fimage/wendang.png',
    'application/x-compress': 'assets/fimage/zip.png',
    'mp3':'assets/fimage/MP3.png',
  };

   static String getStringPath(String ftype){
     
        if(ObjectUtil.isEmptyString(ftype)){
          return fileIcon['file'];
        }else if(ftype.contains('image')){
         return  fileIcon[ftype]!=null?fileIcon[ftype]:fileIcon['image'];
        }else if(ftype.contains('audio')){
          return  fileIcon[ftype]!=null?fileIcon[ftype]:fileIcon['video'];
        }else if(ftype.contains('video')){
          return  fileIcon[ftype]!=null?fileIcon[ftype]:fileIcon['mp3'];
        }else{
          return  fileIcon[ftype]!=null?fileIcon[ftype]:fileIcon['file'];
        }

   }
}