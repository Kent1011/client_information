import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class ClientInformation {
  static const MethodChannel _channel =
      const MethodChannel('client_information');

  /// Get basic client information
  ///
  /// Optional parameters can overwrite the information if provided
  static Future<ClientInformation> fetch({
    String deviceId,
    String osName,
    String osVersion,
    String softwareName,
    String softwareVersion,
    String applicationType,
    String applicationName,
    String applicationVersion,
    String applicationBuildCode,
  }) async {
    var map = await _channel.invokeMethod('getInformation');

    ClientInformation information = (map != null)
        ? ClientInformation._fromMap(Map<String, dynamic>.from(map))
        : ClientInformation();

    if (deviceId?.isNotEmpty ?? false) {
      information.deviceId = deviceId;
    }
    if (osName?.isNotEmpty ?? false) {
      information.osName = osName;
    }
    if (osVersion?.isNotEmpty ?? false) {
      information.osVersion = osVersion;
    }
    if (softwareName?.isNotEmpty ?? false) {
      information.softwareName = softwareName;
    }
    if (softwareVersion?.isNotEmpty ?? false) {
      information.softwareVersion = softwareVersion;
    }
    if (applicationType?.isNotEmpty ?? false) {
      information.applicationType = applicationType;
    }
    if (applicationName?.isNotEmpty ?? false) {
      information.applicationName = applicationName;
    }
    if (applicationVersion?.isNotEmpty ?? false) {
      information.applicationVersion = applicationVersion;
    }
    if (applicationBuildCode?.isNotEmpty ?? false) {
      information.applicationBuildCode = applicationBuildCode;
    }

    return information;
  }

  /// Device ID
  String deviceId;

  /// Device Name
  String deviceName;

  /// Operate system name
  String osName;

  /// Operate system version
  String osVersion;

  /// Software name. And software means if application type [applicationType]
  /// is `app`, this value will be equal to the application
  /// name [applicationName]. If application type [applicationType] is `web`,
  /// then software name will be equal to the browser's name.
  String softwareName;

  /// Software version (application version or browser version)
  String softwareVersion;

  /// Application type
  ///
  /// There are only two types: `app`, `web`
  String applicationType;

  /// Application name
  String applicationName;

  /// Application version
  String applicationVersion;

  /// Application build number
  String applicationBuildCode;

  ClientInformation({
    this.deviceId,
    this.deviceName,
    this.osName,
    this.osVersion,
    this.softwareName,
    this.softwareVersion,
    this.applicationType,
    this.applicationName,
    this.applicationVersion,
    this.applicationBuildCode,
  });

  Map<String, dynamic> _toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'osName': osName,
      'osVersion': osVersion,
      'softwareName': softwareName,
      'softwareVersion': softwareVersion,
      'applicationType': applicationType,
      'applicationName': applicationName,
      'applicationVersion': applicationVersion,
      'applicationBuildCode': applicationBuildCode,
    };
  }

  factory ClientInformation._fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ClientInformation(
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      osName: map['osName'],
      osVersion: map['osVersion'],
      softwareName: map['softwareName'],
      softwareVersion: map['softwareVersion'],
      applicationType: map['applicationType'],
      applicationName: map['applicationName'],
      applicationVersion: map['applicationVersion'],
      applicationBuildCode: map['applicationBuildCode'],
    );
  }

  String toJson() => json.encode(_toMap());

  factory ClientInformation.fromJson(String source) =>
      ClientInformation._fromMap(json.decode(source));
}
