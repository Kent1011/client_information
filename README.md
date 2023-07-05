# Client Information

This is a plugin that lets you get basic information from your application's client. It's easy to use and supports different platforms (Android, iOS, and Web). There are four different information types: "application information", "software information", "operating system information", and "device information".

[![Pub](https://img.shields.io/pub/v/client_information.svg)](https://pub.dev/packages/client_information)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**iOS screenshot**<br>
<img src="https://raw.githubusercontent.com/Kent1011/client_information/master/screens/ios_screenshot.png" width="30%"><br>

**Android screenshot**<br>
<img src="https://raw.githubusercontent.com/Kent1011/client_information/master/screens/android_screenshot.png" width="30%"><br>

**Web screenshot**<br>
<img src="https://raw.githubusercontent.com/Kent1011/client_information/master/screens/web_screenshot.png" width="60%">

## Information Types

There are 4 different types:

1. Application Information
2. Software Information
3. Operating System Information
4. Device Information

### Application Information

Application information is all about the application you build. And notice that **applicationId** is not supported for web applications.

<table>
  <tr>
    <td>Attribute</td>
    <td>iOS</td>
    <td>Android</td>
    <td>Web</td>
  </tr>
  <tr>
    <td><b>applicationId</b><br>String</td>
    <td>O<br>bundleIdentifier</td>
    <td>O<br>package name</td>
    <td>x<br>default: application name</td>
  </tr>
  <tr>
    <td><b>applicationType</b><br>String (app/web)</td>
    <td>O</td>
    <td>O</td>
    <td>O</td>
  </tr>
  <tr>
    <td><b>applicationName</b><br>String</td>
    <td>O</td>
    <td>O</td>
    <td>O</td>
  </tr>
  <tr>
    <td><b>applicationVersion</b><br>String</td>
    <td>O</td>
    <td>O</td>
    <td>O</td>
  </tr>
  <tr>
    <td><b>applicationBuildCode</b><br>String</td>
    <td>O</td>
    <td>O</td>
    <td>O</td>
  </tr>
</table><br>

### Software Information

"Software" stands for the "software" that runs your application, such as "Operating System" for iOS/Android projects or "Browser" for web projects.

<table>
  <tr>
    <td>Attribute</td>
    <td>iOS</td>
    <td>Android</td>
    <td>Web</td>
  </tr>
  <tr>
    <td><b>softwareName</b><br>String</td>
    <td>O<br>OS name</td>
    <td>O<br>OS name</td>
    <td>O<br>Browser name</td>
  </tr>
  <tr>
    <td><b>softwareVersion</b><br>String</td>
    <td>O<br>OS version</td>
    <td>O<br>OS version</td>
    <td>O<br>Browser version</td>
  </tr>
</table><br>

### Operating System Information

OS information will show you the OS's name and version. Notice: Web projects may not get this information if the browser's user-agent doesn't contain any information about the operating system.

<table>
  <tr>
    <td>Attribute</td>
    <td>iOS</td>
    <td>Android</td>
    <td>Web</td>
  </tr>
  <tr>
    <td><b>osName</b><br>String</td>
    <td>O<br>OS name</td>
    <td>O<br>OS name</td>
    <td>*O<br>OS name<br>(*unknown possible)</td>
  </tr>
  <tr>
    <td><b>osVersion</b><br>String</td>
    <td>O<br>OS version</td>
    <td>O<br>OS version</td>
    <td>*O<br>OS Version<br>(*unknown possible)</td>
  </tr>
</table><br>

### Device Information

The device information will display device's ID and name. Note that web projects don't support real **deviceId**, so they will use the package [uuid](https://pub.dev/packages/uuid) to generate a unique string and save to the browser's cookie.

<table>
  <tr>
    <td>Attribute</td>
    <td>iOS</td>
    <td>Android</td>
    <td>Web</td>
  </tr>
  <tr>
    <td><b>deviceId</b><br>String</td>
    <td>O</td>
    <td>O</td>
    <td>O</td>
  </tr>
  <tr>
    <td><b>deviceName</b><br>String</td>
    <td>O</td>
    <td>O</td>
    <td>x<br>default: osName osVersion / browserName browserVersion<br>(e.g. iOS 14 / Chrome 88.0)</td>
  </tr>
</table><br>

## Getting Started

In the pubspec.yaml of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  client_information: ^2.0.4
```

In your project add the following import:

```dart
import 'package:client_information/client_information.dart';
```

Then, you can get information like this:

```dart
// Get client information
ClientInformation info = await ClientInformation.fetch();

print(info.deviceId); // EA625164-4XXX-XXXX-XXXXXXXXXXXX
print(info.osName); // iOS
```

## Mock Data for Test

Starting from version 1.0.2, you can mock data or enable "mockMode" to facilitate testing. Here is how to set it up:

<br>

In your test file:

```dart
setUp(() async {
  // Change to "MockMode" and set the default data you need.
  ClientInformation.mockOn(
      deviceId: 'mock_device_id', osName: 'MyCustomOS');
});

tearDown(() {
  // Close the "MockMode" in tearDown method
  ClientInformation.mockOff();
});

// Run your test
test('`deviceId` will be "mock_device_id"', () async {
  ClientInformation info = await ClientInformation.fetch();
  expect(info.deviceId, 'mock_device_id');
});
```
