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
