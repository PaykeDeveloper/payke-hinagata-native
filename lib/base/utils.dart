import 'package:logger/logger.dart';

final logger = Logger();

Map<K, T> convertListToMap<T, K>(
    List<T> values, K Function(T value) keyMethod) {
  final Map<K, T> result = {};

  for (final value in values) {
    result[keyMethod(value)] = value;
  }

  return result;
}
