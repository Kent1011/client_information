import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:uuid/uuid.dart';

class ClientInformationWeb {
  static const _deviceIdKeyPlaceHolder = '_ci_dik';

  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'client_information',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = ClientInformationWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getInformation':
        return getInformation();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'client_information for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<Map<String, String>> getInformation() async {
    var resultInfo = <String, String>{};

    var applicationType = 'web';
    var applicationVersion = 'unknown_version';
    var applicationBuildCode = '0';
    var applicationName = 'unknown_name';

    var _appMapData = await _getVersionJsonData();
    if (_appMapData.isNotEmpty) {
      if (_appMapData['app_name'] != null) {
        applicationName = _appMapData['app_name'];
      }
      if (_appMapData['version'] != null) {
        applicationVersion = _appMapData['version'];
      }
      if (_appMapData['build_number'] != null) {
        applicationBuildCode = _appMapData['build_number'];
      }
    }

    var os = _getOS();
    var osName = os.name;
    var osVersion = os.version;
    var browser = _getBrowser();
    var deviceId = _getDeviceId();
    var deviceName =
        '${os.name} ${os.version}/${browser.name} ${browser.version}';

    resultInfo['deviceId'] = deviceId;
    resultInfo['deviceName'] = deviceName;
    resultInfo['osName'] = osName;
    resultInfo['osVersion'] = osVersion;
    resultInfo['softwareName'] = browser.name;
    resultInfo['softwareVersion'] = browser.version;
    resultInfo['applicationId'] = applicationName;
    resultInfo['applicationType'] = applicationType;
    resultInfo['applicationName'] = applicationName;
    resultInfo['applicationVersion'] = applicationVersion;
    resultInfo['applicationBuildCode'] = applicationBuildCode;
    return Future.value(resultInfo);
  }

  Future<Map<String, dynamic>> _getVersionJsonData() async {
    var baseUrl = html.window.document.baseUri ?? '';
    if (baseUrl.isEmpty) return {};

    try {
      final versionFilePath =
          '${Uri.parse(baseUrl).removeFragment()}version.json';
      final jsonString = await HttpRequest.getString(versionFilePath);

      if (jsonString.isEmpty) {
        return {};
      } else {
        return json.decode(jsonString);
      }
    } catch (error) {
      return {};
    }
  }

  String _getDeviceId() {
    var deviceIdKey = _initialDeviceIdKey();
    var key = '${ClientInformationWeb._deviceIdKeyPlaceHolder}_$deviceIdKey';
    var deviceId = _getCookieValue(key);

    if (deviceId != null) {
      return deviceId;
    } else {
      deviceId = Uuid().v4();
      _setCookie(key, deviceId);
      return deviceId;
    }
  }

  String _initialDeviceIdKey() {
    var deviceIdKey = _getDeviceIdKey();
    if (deviceIdKey == null) _setDeviceIdKey();
    deviceIdKey = _getDeviceIdKey();
    return deviceIdKey!;
  }

  void _setDeviceIdKey() {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    _setCookie('${ClientInformationWeb._deviceIdKeyPlaceHolder}_$timestamp',
        timestamp.toString());
  }

  String? _getDeviceIdKey() =>
      _getCookieValue(ClientInformationWeb._deviceIdKeyPlaceHolder,
          similar: true);

  void _setCookie(String key, String value) {
    html.window.document.cookie = '$key=$value';
  }

  String? _getCookieValue(String key, {bool similar = false}) {
    var cookieStr = html.window.document.cookie;
    if (cookieStr == null || cookieStr == '') return null;

    var el = cookieStr
        .split('; ')
        .firstWhere((row) => row.startsWith(similar ? key : '$key='),
            orElse: () => '')
        .split('=');
    return el.length > 1 ? el.elementAt(1) : null;
  }

  _Software _getOS() {
    var userAgent = html.window.navigator.userAgent,
        platform = html.window.navigator.platform,
        macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
        windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
        iosPlatforms = ['iPhone', 'iPad', 'iPod'],
        osName,
        osVersion;
    if (macosPlatforms.contains(platform)) {
      osName = 'Mac OS';
    } else if (iosPlatforms.contains(platform)) {
      osName = 'iOS';
    } else if (windowsPlatforms.contains(platform)) {
      osName = 'Windows';
    } else if (RegExp(r'Android').hasMatch(userAgent)) {
      osName = 'Android';
    } else if (RegExp(r'Linux').hasMatch(userAgent)) {
      osName = 'Linux';
    } else if (RegExp(r'CrOS').hasMatch(userAgent)) {
      osName = 'Chrome OS';
    } else if (RegExp(r'Remix', caseSensitive: false).hasMatch(userAgent)) {
      osName = 'Remix OS';
    }

    switch (osName) {
      case 'Mac OS':
        osVersion = _softwareVersion(userAgent,
                RegExp(r'(mac os x) ([\d\_]+)', caseSensitive: false))
            ?.replaceAll(r'_', '.');
        break;
      case 'iOS':
        osVersion = _softwareVersion(
                userAgent,
                RegExp(r'(cpu os|cpu iphone os) ([\d\_]+)',
                    caseSensitive: false))
            ?.replaceAll(r'_', '.');
        break;
      case 'Windows':
        osVersion = _softwareVersion(
            userAgent, RegExp(r'(windows nt) ([\d\.]+)', caseSensitive: false));
        break;
      case 'Android':
        osVersion = _softwareVersion(
            userAgent, RegExp(r'(android) ([\d\.]+)', caseSensitive: false));
        break;
      case 'Chrome OS':
        osVersion = _softwareVersion(
            userAgent,
            RegExp(r'(cros x86_64|cros armv7l|cros aarch64) ([\d\.]+)',
                caseSensitive: false));
        break;
      default:
        osVersion = userAgent;
        break;
    }

    return _Software(osName ?? 'unknown_os', osVersion ?? 'unknown_os_version');
  }

  _Software _getBrowser() {
    var userAgent = html.window.navigator.userAgent;
    var browser = 'unknown_browser';
    String? browserVersion = '0.0.0';

    browser = RegExp(r'ucbrowser', caseSensitive: false).hasMatch(userAgent)
        ? 'UCBrowser'
        : browser;
    browser = RegExp(r'edge|edg', caseSensitive: false).hasMatch(userAgent)
        ? 'Edge'
        : browser;
    browser = RegExp(r'googlebot', caseSensitive: false).hasMatch(userAgent)
        ? 'GoogleBot'
        : browser;
    browser = RegExp(r'chromium', caseSensitive: false).hasMatch(userAgent)
        ? 'Chromium'
        : browser;
    browser = RegExp(r'(firefox|fxios)', caseSensitive: false)
                .hasMatch(userAgent) &&
            RegExp(r'seamonkey', caseSensitive: false).hasMatch(userAgent) ==
                false
        ? 'Firefox'
        : browser;
    browser = RegExp(r'; (msie|trident)', caseSensitive: false)
                .hasMatch(userAgent) &&
            RegExp(r'ucbrowser', caseSensitive: false).hasMatch(userAgent) ==
                false
        ? 'IE'
        : browser;
    browser =
        RegExp(r'chrome|crios', caseSensitive: false).hasMatch(userAgent) &&
                RegExp(r'(opr|opera|chromium|edg|ucbrowser|googlebot|; wv)',
                            caseSensitive: false)
                        .hasMatch(userAgent) ==
                    false
            ? 'Chrome'
            : browser;
    browser = RegExp(r'safari', caseSensitive: false).hasMatch(userAgent) &&
            RegExp(r'(chromium|edg|ucbrowser|chrome|crios|opr|opera|fxios|firefox)',
                        caseSensitive: false)
                    .hasMatch(userAgent) ==
                false
        ? 'Safari'
        : browser;
    browser = RegExp(r'(opr|opera)', caseSensitive: false).hasMatch(userAgent)
        ? 'Opera'
        : browser;
    browser = RegExp(r'silk', caseSensitive: false).hasMatch(userAgent)
        ? 'Silk'
        : browser;
    browser = RegExp(r'FBAN\/', caseSensitive: false).hasMatch(userAgent)
        ? 'FB APP'
        : browser;
    browser = RegExp(r'snapchat\/', caseSensitive: false).hasMatch(userAgent)
        ? 'Snapchat APP'
        : browser;
    browser = RegExp(r'instagram', caseSensitive: false).hasMatch(userAgent)
        ? 'Instagram APP'
        : browser;
    browser = RegExp(r'line\/', caseSensitive: false).hasMatch(userAgent)
        ? 'LINE APP'
        : browser;

    if (browser == 'unknown_browser' && RegExp(r'; wv').hasMatch(userAgent)) {
      browser = 'WebView';
    }

    switch (browser) {
      case 'UCBrowser':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'([\d\.]+)', caseSensitive: false));
        break;
      case 'Edge':
        browserVersion = _softwareVersion(userAgent,
            RegExp(r'(edge|edga|edgios|edg)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'GoogleBot':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(googlebot)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Chromium':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(chromium)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Firefox':
        browserVersion = _softwareVersion(userAgent,
            RegExp(r'(firefox|fxios)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Chrome':
        browserVersion = _softwareVersion(userAgent,
            RegExp(r'(chrome|crios)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Safari':
        if (RegExp(r'(version)\/([\d.]+)', caseSensitive: false)
            .hasMatch(userAgent)) {
          browserVersion = _softwareVersion(
              userAgent, RegExp(r'(version)\/([\d\.]+)', caseSensitive: false));
        } else {
          browserVersion = _softwareVersion(
              userAgent, RegExp(r'(safari)\/([\d\.]+)', caseSensitive: false));
        }
        break;
      case 'Opera':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(opera|opr)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'IE':
        var tridentVersion = _softwareVersion(
          userAgent,
          RegExp(r'(trident)\/([\d\.]+)', caseSensitive: false),
        );
        var ieVersion = _softwareVersion(
            userAgent, RegExp(r'(MSIE) ([\d\.]+)', caseSensitive: false));
        browserVersion = tridentVersion != null
            ? (double.parse(tridentVersion) + 4.0).toString()
            : (ieVersion ?? '0.0.0');
        break;
      case 'Silk':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(silk)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'FB APP':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(fbsv)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Snapchat APP':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(snapchat)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'Instagram APP':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(instagram) ([\d\.]+)', caseSensitive: false));
        break;
      case 'LINE APP':
        browserVersion = _softwareVersion(
            userAgent, RegExp(r'(line)\/([\d\.]+)', caseSensitive: false));
        break;
      case 'WebView':
        browserVersion = userAgent;
        break;
      default:
        browserVersion = '0.0.0';
        break;
    }

    return _Software(browser, browserVersion ?? '0.0.0');
  }

  String? _softwareVersion(String userAgent, RegExp regex) {
    return regex.hasMatch(userAgent)
        ? regex.allMatches(userAgent).elementAt(0).group(2)
        : null;
  }
}

class _Software {
  String name;
  String version;

  _Software(
    this.name,
    this.version,
  );
}
