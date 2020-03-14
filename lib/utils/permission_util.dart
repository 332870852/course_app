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

  static Future<bool> requestPermission(
      {@required PermissionGroup permissionGroup}) async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.access_media_location]);
    if (permissions[permissionGroup] == PermissionStatus.granted) {
      return true;
    } else {
      print('需要权限!');
      return false;
    }
  }

  static Future<PermissionStatus> findPermissionStatus(
      {@required PermissionGroup permissionGroup}) async {
    PermissionStatus permissions =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    return permissions;
  }

  static Future<ServiceStatus> findServicePermission(
      {@required PermissionGroup permissionGroup}) async {
    ServiceStatus serviceStatus =
        await PermissionHandler().checkServiceStatus(permissionGroup);
    return serviceStatus;
  }

  static Future<bool> openAppSettings() async {
    return await PermissionHandler().openAppSettings();
  }
}
