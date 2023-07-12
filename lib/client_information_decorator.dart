part of 'client_information.dart';

/// A decorator for [ClientInformation]
///
/// [T] is the type of the value to be decorated
/// oriInfo is the original [ClientInformation] object
/// value is the value to be decorated
typedef ClientInformationDecorator<T> = T Function(
  ClientInformation oriInfo,
  T value,
);

/// Decorators for [ClientInformation]
class ClientInformationDecorators {
  final ClientInformationDecorator<String>? deviceId;
  final ClientInformationDecorator<String>? osName;
  final ClientInformationDecorator<String>? osVersion;
  final ClientInformationDecorator<String>? softwareName;
  final ClientInformationDecorator<String>? softwareVersion;
  final ClientInformationDecorator<String>? applicationId;
  final ClientInformationDecorator<String>? applicationType;
  final ClientInformationDecorator<String>? applicationName;
  final ClientInformationDecorator<String>? applicationVersion;
  final ClientInformationDecorator<String>? applicationBuildCode;

  ClientInformationDecorators({
    this.deviceId,
    this.osName,
    this.osVersion,
    this.softwareName,
    this.softwareVersion,
    this.applicationId,
    this.applicationType,
    this.applicationName,
    this.applicationVersion,
    this.applicationBuildCode,
  });
}

/// The extension methods for [ClientInformation]
extension ClientInformationExtension on ClientInformation {
  /// Decorate the [ClientInformation] object by providing decorators.
  ///
  ClientInformation decoration({
    ClientInformationDecorator<String>? deviceId,
    ClientInformationDecorator<String>? osName,
    ClientInformationDecorator<String>? osVersion,
    ClientInformationDecorator<String>? softwareName,
    ClientInformationDecorator<String>? softwareVersion,
    ClientInformationDecorator<String>? applicationId,
    ClientInformationDecorator<String>? applicationType,
    ClientInformationDecorator<String>? applicationName,
    ClientInformationDecorator<String>? applicationVersion,
    ClientInformationDecorator<String>? applicationBuildCode,
  }) {
    var decorators = ClientInformationDecorators(
      deviceId: deviceId,
      osName: osName,
      osVersion: osVersion,
      softwareName: softwareName,
      softwareVersion: softwareVersion,
      applicationId: applicationId,
      applicationType: applicationType,
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationBuildCode: applicationBuildCode,
    );

    return _clientInfoDecorationHandler(this, decorators);
  }
}

/// The handler for [ClientInformation] decoration
///
/// [oriInfo] is the original [ClientInformation] object
/// [decorators] is the decorators for [ClientInformation]
ClientInformation _clientInfoDecorationHandler(
    ClientInformation oriInfo, ClientInformationDecorators decorators) {
  var decoratedInfo = oriInfo;

  // device decoration
  if (decorators.deviceId != null) {
    decoratedInfo.deviceId =
        decorators.deviceId!(oriInfo, decoratedInfo.deviceId);
  }

  // os decoration
  if (decorators.osName != null) {
    decoratedInfo.osName = decorators.osName!(oriInfo, decoratedInfo.osName);
  }
  if (decorators.osVersion != null) {
    decoratedInfo.osVersion =
        decorators.osVersion!(oriInfo, decoratedInfo.osVersion);
  }

  // software decoration
  if (decorators.softwareName != null) {
    decoratedInfo.softwareName =
        decorators.softwareName!(oriInfo, decoratedInfo.softwareName);
  }
  if (decorators.softwareVersion != null) {
    decoratedInfo.softwareVersion =
        decorators.softwareVersion!(oriInfo, decoratedInfo.softwareVersion);
  }

  // application decoration
  if (decorators.applicationId != null) {
    decoratedInfo.applicationId =
        decorators.applicationId!(oriInfo, decoratedInfo.applicationId);
  }
  if (decorators.applicationType != null) {
    decoratedInfo.applicationType =
        decorators.applicationType!(oriInfo, decoratedInfo.applicationType);
  }
  if (decorators.applicationName != null) {
    decoratedInfo.applicationName =
        decorators.applicationName!(oriInfo, decoratedInfo.applicationName);
  }
  if (decorators.applicationVersion != null) {
    decoratedInfo.applicationVersion = decorators.applicationVersion!(
        oriInfo, decoratedInfo.applicationVersion);
  }
  if (decorators.applicationBuildCode != null) {
    decoratedInfo.applicationBuildCode = decorators.applicationBuildCode!(
        oriInfo, decoratedInfo.applicationBuildCode);
  }

  return decoratedInfo;
}
