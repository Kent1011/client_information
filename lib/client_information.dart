import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ClientInformation {
  static const MethodChannel _channel =
      const MethodChannel('client_information');

  /// A flag to identify testing mode
  static bool _isMockMode = false;

  /// Mock data for test
  static late final ClientInformation _mockData;

  /// Get basic client information
  ///
  /// Optional parameters can overwrite the information if provided
  static Future<ClientInformation> fetch({
    String? deviceId,
    String? osName,
    String? osVersion,
    String? softwareName,
    String? softwareVersion,
    String? applicationId,
    String? applicationType,
    String? applicationName,
    String? applicationVersion,
    String? applicationBuildCode,
  }) async {
    ClientInformation information;

    if (_isMockMode == true) {
      print('ClientInformation Warning ! You\'re in test mode.');
      information = _mockData;
    } else {
      var map = await _channel.invokeMethod('getInformation');
      information = map != null
          ? ClientInformation._fromMap(Map<String, dynamic>.from(map))
          : ClientInformation();
    }

    if (deviceId?.isNotEmpty ?? false) {
      information.deviceId = deviceId!;
    }
    if (osName?.isNotEmpty ?? false) {
      information.osName = osName!;
    }
    if (osVersion?.isNotEmpty ?? false) {
      information.osVersion = osVersion!;
    }
    if (softwareName?.isNotEmpty ?? false) {
      information.softwareName = softwareName!;
    }
    if (softwareVersion?.isNotEmpty ?? false) {
      information.softwareVersion = softwareVersion!;
    }
    if (applicationId?.isNotEmpty ?? false) {
      information.applicationId = applicationId!;
    }
    if (applicationType?.isNotEmpty ?? false) {
      information.applicationType = applicationType!;
    }
    if (applicationName?.isNotEmpty ?? false) {
      information.applicationName = applicationName!;
    }
    if (applicationVersion?.isNotEmpty ?? false) {
      information.applicationVersion = applicationVersion!;
    }
    if (applicationBuildCode?.isNotEmpty ?? false) {
      information.applicationBuildCode = applicationBuildCode!;
    }

    return information;
  }

  /// Change to test mode.
  @visibleForTesting
  static void mockOn({
    String? deviceId,
    String? osName,
    String? osVersion,
    String? softwareName,
    String? softwareVersion,
    String? applicationId,
    String? applicationType,
    String? applicationName,
    String? applicationVersion,
    String? applicationBuildCode,
  }) {
    _isMockMode = true;
    _mockData = ClientInformation();

    if (deviceId?.isNotEmpty ?? false) {
      _mockData.deviceId = deviceId!;
    }
    if (osName?.isNotEmpty ?? false) {
      _mockData.osName = osName!;
    }
    if (osVersion?.isNotEmpty ?? false) {
      _mockData.osVersion = osVersion!;
    }
    if (softwareName?.isNotEmpty ?? false) {
      _mockData.softwareName = softwareName!;
    }
    if (softwareVersion?.isNotEmpty ?? false) {
      _mockData.softwareVersion = softwareVersion!;
    }
    if (applicationId?.isNotEmpty ?? false) {
      _mockData.applicationId = applicationId!;
    }
    if (applicationType?.isNotEmpty ?? false) {
      _mockData.applicationType = applicationType!;
    }
    if (applicationName?.isNotEmpty ?? false) {
      _mockData.applicationName = applicationName!;
    }
    if (applicationVersion?.isNotEmpty ?? false) {
      _mockData.applicationVersion = applicationVersion!;
    }
    if (applicationBuildCode?.isNotEmpty ?? false) {
      _mockData.applicationBuildCode = applicationBuildCode!;
    }
  }

  /// Stop test mode.
  @visibleForTesting
  static void mockOff() {
    _isMockMode = false;
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

  /// Application ID
  ///
  /// Android: package name
  /// iOS: bundleIdentifier
  /// Web: application name
  String applicationId;

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
    String? deviceId,
    String? deviceName,
    String? osName,
    String? osVersion,
    String? softwareName,
    String? softwareVersion,
    String? applicationId,
    String? applicationType,
    String? applicationName,
    String? applicationVersion,
    String? applicationBuildCode,
  })  : deviceId = deviceId ?? 'unknown_device_id',
        deviceName = deviceName ?? 'unknown_device_name',
        osName = osName ?? 'unknown_os_name',
        osVersion = osVersion ?? 'unknown_os_version',
        softwareName = softwareName ?? 'unknown_software_name',
        softwareVersion = softwareVersion ?? 'unknown_software_version',
        applicationId = applicationId ?? 'unknown_application_id',
        applicationType = applicationType ?? 'unknown_application_type',
        applicationName = applicationName ?? 'unknown_application_name',
        applicationVersion =
            applicationVersion ?? 'unknown_application_version',
        applicationBuildCode =
            applicationBuildCode ?? 'unknown_application_build_code';

  Map<String, dynamic> _toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'osName': osName,
      'osVersion': osVersion,
      'softwareName': softwareName,
      'softwareVersion': softwareVersion,
      'applicationId': applicationId,
      'applicationType': applicationType,
      'applicationName': applicationName,
      'applicationVersion': applicationVersion,
      'applicationBuildCode': applicationBuildCode,
    };
  }

  factory ClientInformation._fromMap(Map<String, dynamic>? map) {
    if (map == null) return ClientInformation();

    return ClientInformation(
      deviceId: map['deviceId'] ?? 'unknown_device_id',
      deviceName: map['deviceName'] ?? 'unknown_device_name',
      osName: map['osName'] ?? 'unknown_os_name',
      osVersion: map['osVersion'] ?? 'unknown_os_version',
      softwareName: map['softwareName'] ?? 'unknown_software_name',
      softwareVersion: map['softwareVersion'] ?? 'unknown_software_version',
      applicationId: map['applicationId'] ?? 'unknown_application_id',
      applicationType: map['applicationType'] ?? 'unknown_application_type',
      applicationName: map['applicationName'] ?? 'unknown_application_name',
      applicationVersion:
          map['applicationVersion'] ?? 'unknown_application_version',
      applicationBuildCode:
          map['applicationBuildCode'] ?? 'unknown_application_build_code',
    );
  }

  String toJson() => json.encode(_toMap());

  factory ClientInformation.fromJson(String source) =>
      ClientInformation._fromMap(json.decode(source));
}
