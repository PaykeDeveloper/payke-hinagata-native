// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:native_app/base/constants.dart';
import 'package:native_app/base/preference.dart';

final dio = _getDio();

Future<Response> get<T>(String path) async {
  final options = await _getOptions();
  try {
    final response = await dio.get(path, options: options);
    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

Future<Response> post<T>(String path, Map<String, dynamic> data,
    {bool useFormData = false}) async {
  final options = await _getOptions();
  final convertedData = useFormData ? FormData.fromMap(data) : data;
  try {
    final response =
        await dio.post(path, data: convertedData, options: options);
    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

Future<Response> put<T>(String path, Map<String, dynamic> data,
    {bool useFormData = false}) async {
  final options = await _getOptions();
  options.headers['X-HTTP-Method-Override'] = 'PATCH';
  final convertedData = useFormData ? FormData.fromMap(data) : data;
  try {
    final response =
        await dio.post(path, data: convertedData, options: options);
    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

Future<Response> delete<T>(String path) async {
  final options = await _getOptions();
  try {
    final response = await dio.delete(path, options: options);
    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

Dio _getDio() {
  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  return Dio(options);
}

Future<Options> _getOptions() async {
  final Map<String, dynamic> headers = {
    'Accept': 'application/json',
  };

  final token = await Preference.token.get();
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }

  final language = await Preference.language.get();
  if (language != null) {
    headers['Accept-Language'] = language;
  }

  return Options(headers: headers);
}
