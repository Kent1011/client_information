## 2.2.0

### ✨ Enhancements

- Upgraded Android Gradle Plugin and migrated to `plugins {}` syntax (removed `apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"`).
- Updated Gradle to **7.5+** and upgraded Gradle Wrapper to **8.10.2**.
- Increased **Android minSdkVersion to 21** for better compatibility.
- Increased **iOS minSdkVersion to 12.0** to enhance compatibility and security.
- Changed Flutter Web initialization to use `flutter_bootstrap.js` instead of `flutter.js`.
- Converted `build.gradle` to **Kotlin DSL (`build.gradle.kts`)** for better maintainability.

### 🐞 Fixes

- Removed deprecated `apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"` to prevent `Flutter Plugin Imperative Apply` errors.
- Fixed `ClientInformationPlugin` by removing `registerWith(Registrar)`, aligning with the new Flutter Plugin API.
- Fixed Issues [#15](https://github.com/Kent1011/client_information/issues/15), [PR:#16](https://github.com/Kent1011/client_information/pull/16) (Thanks @fegea-immo), [PR:#17](https://github.com/Kent1011/client_information/pull/17) (Thanks @mortuzahossain), [#19](https://github.com/Kent1011/client_information/issues/19)

### 🔼 Dependency Updates

- **Dart SDK**: `>=3.0.5` → `>=3.7.0`
- **Flutter SDK**: `>=3.18.0`
- **Kotlin**: `1.7.10` → `1.8.22`
- **flutter_lints**: `2.0.0` → `5.0.0`
- **cupertino_icons**: `1.0.2` → `1.0.8`
- Other dependencies have been updated for better compatibility.

### 🚀 Migration Guide

This update **is not a breaking change**, but if your project:

- Has `minSdkVersion < 21` on Android, update it to `21`.
- Has `minSdkVersion < 12.0` on iOS, update your `Podfile` (`platform :ios, '12.0'`).
- Uses `build.gradle`, you may consider migrating to `build.gradle.kts`, but it's optional.

> **Recommended commands to ensure a clean update:**

```sh
flutter clean
flutter pub get
flutter build apk # or flutter build ios
```

## 2.1.4

- chore: upgrade package `uuid`'s version

## 2.1.3

- fix: Problem with `osVersionCode`` number([#13](https://github.com/Kent1011/client_information/issues/13))

## 2.1.2

- doc: Update README.md

## 2.1.1

- feat: support `osVersionCode`([#11](https://github.com/Kent1011/client_information/issues/11))

## 2.1.0

- feature: Adding decorator method to decorate the information.

  ```dart
  var information = await ClientInformation.fetch(
      // you can pass decorators to decoration the value before it return.
      decorators: ClientInformationDecorators(
        deviceId: (oriInfo, value) =>
            'prefix-$value-${oriInfo.applicationName}',
      ),
    );

  // or you can use extension methods like this:
  var information = await ClientInformation.fetch();
  var decoratedInfo = information.decoration(deviceId: (oriInfo, value) => '$value-some-suffix-string-here');
  ```

- fix: update Android gradle setting. ([#10](https://github.com/Kent1011/client_information/issues/10), Thanks @pnghai)
- doc: Update the example project & README.md

## 2.0.4

- fix: Edge Chromium check missing([#12](https://github.com/Kent1011/client_information/issues/12), Thanks @DaggeDaggmask)
- chore: Fix code lint issues.
- refactor: Update example project to support null-safety.

## 2.0.3+1

- doc: Update README.md

## 2.0.3

- fix: Web Exception caused by [non_bool_negation_expression](https://dart.dev/tools/diagnostic-messages#non_bool_negation_expression)([#6](https://github.com/Kent1011/client_information/issues/6), [#7](https://github.com/Kent1011/client_information/issues/7)) (Thanks @MarcVanDaele90)

- Upgrade [uuid](https://pub.dev/packages/uuid) 3.0.3 -> 3.0.6

## 2.0.2+2

- Update document

## 2.0.2+1

- chore: code formatter

## 2.0.2

- fix: fix initialization on web ([#4](https://github.com/Kent1011/client_information/pull/4))

## 2.0.1

- fix: Web exception when get deviceID ([#1](https://github.com/Kent1011/client_information/issues/1))

## 2.0.0

- null-safety support

## 1.1.0+1

- Fix: static analysis (`pana`) using stable version

## 1.1.0

- Remove package `http` dependency.
- Replace dependency 'ulid' -> 'uuid'.
- Use `pedantic`.

## 2.0.0-nullsafety.0

- Migrate package to null-safety, increase minimum SDK version to 2.12, replace dependency 'ulid' -> 'uuid'.

## 1.0.4

- Update document.

## 1.0.3

- Fix some document error.

## 1.0.2

- New attribute _deviceName_ : Show the device name like "iPhone", "iPad", "Pixel"...
- New attribute _applicationId_ : Show you the application ID (\*Not support for web project)
- Support test mode.

  ```dart
  // ...
  setUp(() async {
    ClientInformation.mockOn(
        deviceId: 'mock_device_id', osName: 'MyCustomOS');
  });

  tearDown(() {
    ClientInformation.mockOff();
  });

  test('Custom `deviceId` will be "mock_device_id"', () async {
    ClientInformation info = await ClientInformation.fetch();
    expect(info.deviceId, 'mock_device_id');
  });

  // ...
  ```

- Update document: README.md

## 1.0.1

- Update document: README.md
- Remove "author" section from pubspec.yaml

## 1.0.0

- Initial release
