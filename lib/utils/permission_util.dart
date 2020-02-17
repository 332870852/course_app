import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> requestAmapPermission() async {
    final permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      return true;
    } else {
      print('需要定位权限!');
      return false;
    }
  }

  static Future<bool> requestQRcodePermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      return true;
    } else {
      print('需要相机权限!');
      return false;
    }
  }
}
