import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:client_information/client_information.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ClientInformation _clientInfo;

  @override
  void initState() {
    super.initState();
    _getClientInformation();
  }

  Future<void> _getClientInformation() async {
    ClientInformation info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {
      print('Failed to get client information');
    }
    if (!mounted) return;

    setState(() {
      _clientInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Client Information'),
        ),
        body: LayoutBuilder(builder: (context, _) {
          return _clientInfo == null ? _buildLoading() : _buildBody();
        }),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _generateRowData(
            'deviceId', _clientInfo.deviceId ?? 'unknown_device_id'),
        _generateRowData(
            'deviceName', _clientInfo.deviceName ?? 'unknown_device_name'),
        _generateRowData('osName', _clientInfo.osName ?? 'unknown_os_name'),
        _generateRowData(
            'osVersion', _clientInfo.osVersion ?? 'unknown_os_version'),
        _generateRowData('softwareName',
            _clientInfo.softwareName ?? 'unknown_software_name'),
        _generateRowData('softwareVersion',
            _clientInfo.softwareVersion ?? 'unknown_software_version'),
        _generateRowData('applicationId',
            _clientInfo.applicationId ?? 'unknown_application_id'),
        _generateRowData('applicationType',
            _clientInfo.applicationType ?? 'unknown_application_type'),
        _generateRowData('applicationName',
            _clientInfo.applicationName ?? 'unknown_application_name'),
        _generateRowData('applicationVersion',
            _clientInfo.applicationVersion ?? 'unknown_application_version'),
        _generateRowData(
            'applicationBuildCode',
            _clientInfo.applicationBuildCode ??
                'unknown_application_build_number'),
      ],
    );
  }

  Widget _generateRowData(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        children: [
          Text('$key: ',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value ?? 'null',
              style: const TextStyle(fontSize: 20, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}
