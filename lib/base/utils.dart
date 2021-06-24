import 'package:logger/logger.dart';

final logger = Logger();

extension MapExt on Map {
  Return parse<Return, Value>(String key, Return Function(Value value) parse) {
    final value = this[key] as Value;
    return parse(value);
  }

  Return? tryParse<Return, Value>(
      String key, Return? Function(Value value) parse) {
    final value = this[key] as Value?;
    if (value == null) {
      return null;
    }
    return parse(value);
  }
}

Map<K, T> convertListToMap<T, K>(List<T> values, K Function(T value) key) {
  final Map<K, T> result = {};

  for (final value in values) {
    result[key(value)] = value;
  }

  return result;
}
