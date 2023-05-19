// FIXME: SAMPLE CODE
import 'package:native_app/base/preference.dart';
import 'package:native_app/store/base/notifiers/preference.dart';
import 'package:native_app/store/state/app/preference.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class DivisionIdState extends _$DivisionIdState
    with PreferenceMixin<DivisionId, int> {
  @override
  FutureOr<DivisionId?> build() async => buildDefault();

  @override
  Preference<int> getPreference() => divisionId;

  @override
  int serialize(DivisionId state) => state.value;

  @override
  DivisionId deserialize(int preference) => DivisionId(preference);
}
