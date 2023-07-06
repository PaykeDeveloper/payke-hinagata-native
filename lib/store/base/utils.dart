import 'package:get_it/get_it.dart';
import 'package:native_app/base/api_client.dart';

final getIt = _createGetIt();

GetIt _createGetIt() {
  final getIt = GetIt.instance;
  getIt.registerFactoryParam<ApiClient, String, void>(
      (url, _) => ApiClientImpl(url: url));
  return getIt;
}
