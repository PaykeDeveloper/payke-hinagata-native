// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/division.dart';
import './models/division_input.dart';
import './models/division_url.dart';
import './models/divisions_url.dart';

part 'notifier.g.dart';

@riverpod
class DivisionsState extends _$DivisionsState
    with
        EntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl,
            DivisionInput, DivisionInput> {
  @override
  EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> build() =>
      const EntitiesState();

  @override
  String getEntitiesUrl(DivisionsUrl url) => '/api/v1/divisions';

  @override
  String getEntityUrl(DivisionUrl url) => '/api/v1/divisions/${url.id.value}';

  @override
  Division decodeEntities(Map<String, dynamic> json) => Division.fromJson(json);

  @override
  Division decodeEntity(Map<String, dynamic> json) => Division.fromJson(json);
}
