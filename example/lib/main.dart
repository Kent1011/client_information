import 'package:client_information/client_information.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ClientInformation? basicInfo, decoratedInfo;

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  void _fetchInfo() async {
    basicInfo = await ClientInformation.fetch();

    decoratedInfo = await ClientInformation.fetch(
      decorators: ClientInformationDecorators(
        deviceId: (oriInfo, value) =>
            'prefix-$value-${oriInfo.applicationName}',
      ),
    );

    ///! or, you can use the extension method like this:
    // decoratedInfo = (await ClientInformation.fetch()).decoration(
    //     deviceId: (oriInfo, value) =>
    //         'prefix-$value-${oriInfo.applicationName}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Client Information Example'),
      ),
      body: LayoutBuilder(builder: (context, _) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: basicInfo == null || decoratedInfo == null
                    ? _buildLoading()
                    : _buildInfoView(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dataItemWidget('deviceId', basicInfo?.deviceId ?? 'unknown_device_id'),
        _dataItemWidget('decorated deviceId',
            decoratedInfo?.deviceId ?? 'unknown_decorated_device_id'),
        _dataItemWidget(
            'deviceName', basicInfo?.deviceName ?? 'unknown_device_name'),
        _dataItemWidget('osName', basicInfo?.osName ?? 'unknown_os_name'),
        _dataItemWidget(
            'osVersion', basicInfo?.osVersion ?? 'unknown_os_version'),
        _dataItemWidget(
            'softwareName', basicInfo?.softwareName ?? 'unknown_software_name'),
        _dataItemWidget('softwareVersion',
            basicInfo?.softwareVersion ?? 'unknown_software_version'),
        _dataItemWidget('applicationId',
            basicInfo?.applicationId ?? 'unknown_application_id'),
        _dataItemWidget('applicationType',
            basicInfo?.applicationType ?? 'unknown_application_type'),
        _dataItemWidget('applicationName',
            basicInfo?.applicationName ?? 'unknown_application_name'),
        _dataItemWidget('applicationVersion',
            basicInfo?.applicationVersion ?? 'unknown_application_version'),
        _dataItemWidget(
            'applicationBuildCode',
            basicInfo?.applicationBuildCode ??
                'unknown_application_build_number'),
      ],
    );
  }

  Widget _dataItemWidget(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        children: [
          Text('$key: ',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value ?? 'null',
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
