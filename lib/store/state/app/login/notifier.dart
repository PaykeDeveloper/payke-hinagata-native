import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/backend_client/notifier.dart';
import 'package:native_app/store/state/app/backend_token/notifier.dart';
import 'package:package_info/package_info.dart';

import './models/login_input.dart';
import './models/login_output.dart';

class Login {}

const _web = 'web';

typedef LoginState = StoreState<Login>;

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref) : super(StoreState(Login()));
  final Ref _ref;

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
    final client = _ref.read(backendClientProvider);
    final result = await client.postObject(
        decode: (json) => LoginOutput.fromJson(json),
        path: '/api/v1/login',
        data: input);
    if (result is Success<LoginOutput>) {
      state = state.copyWith(status: StateStatus.done, error: null);
      await _ref
          .read(backendTokenProvider.notifier)
          .setToken(result.data.token);
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

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
    (ref) => LoginNotifier(ref));
