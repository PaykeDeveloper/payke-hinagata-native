import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/models/backend_client.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:package_info/package_info.dart';
import 'package:state_notifier/state_notifier.dart';

import './models/login_input.dart';
import './models/login_output.dart';

class Login {}

const _web = 'web';

typedef LoginState = StoreState<Login>;

class LoginNotifier extends StateNotifier<LoginState> with LocatorMixin {
  LoginNotifier() : super(StoreState(Login()));

  Future<StoreResult<LoginOutput>> login(String email, String password) async {
    final packageName = await _getPackageName();
    final platformType = await _getPlatformType();
    final deviceId = await _getDeviceId();
    final input = LoginInput(
      email: email,
      password: password,
      packageName: packageName,
      platformType: platformType,
      deviceId: deviceId,
    );
    state = state.copyWith(status: StateStatus.started);
    final client = read<BackendClient>();
    final result = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: 'api/v1/login/',
        data: input);
    if (result is Success<LoginOutput>) {
      state = state.copyWith(status: StateStatus.done, error: null);
      await read<BackendTokenNotifier>().setToken(result.data.token);
    } else if (result is Failure<LoginOutput>) {
      state = state.copyWith(status: StateStatus.failed, error: result.error);
    }
    return result;
  }

  Future<String> _getPackageName() async {
    if (kIsWeb) {
      return _web;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> _getPlatformType() async {
    if (kIsWeb) {
      return _web;
    }
    return Platform.operatingSystem;
  }

  Future<String?> _getDeviceId() async {
    if (kIsWeb) {
      return null;
    }

    final deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    }
    return deviceId?.isNotEmpty == true ? deviceId : null;
  }
}
