import 'package:flutter_test/flutter_test.dart';
import 'package:client_information/client_information.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClientInformation.fetch', () {
    setUp(() async {
      ClientInformation.mockOn(
          deviceId: 'mock_device_id', osName: 'MyCustomOS');
    });

    tearDown(() {
      ClientInformation.mockOff();
    });

    test('return type will be a ClientInformation', () async {
      ClientInformation info = await ClientInformation.fetch();
      expect(info, isA<ClientInformation>());
    });

    test('And `deviceId` will be "mock_device_id"', () async {
      ClientInformation info = await ClientInformation.fetch();
      expect(info.deviceId, 'mock_device_id');
    });

    test('And `osName` will be "MyCustomOS"', () async {
      ClientInformation info = await ClientInformation.fetch();
      expect(info.osName, 'MyCustomOS');
    });
  });
}
