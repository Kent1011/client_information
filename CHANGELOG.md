## 1.1.0

- Remove package `http` dependency.
- Replace dependency 'ulid' -> 'uuid'.
- Use `pedantic`.

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
