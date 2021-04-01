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
