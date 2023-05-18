// FIXME: SAMPLE CODE
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './models/division.dart';
import './models/division_input.dart';
import './models/division_url.dart';
import './models/divisions_url.dart';

part 'notifier.g.dart';

@Riverpod(keepAlive: true)
class DivisionsState extends _$DivisionsState
    with
        EntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl>,
        FetchEntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl>,
        CreateEntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl,
            DivisionInput>,
        UpdateEntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl,
            DivisionInput>,
        DeleteEntitiesMixin<Division, DivisionUrl, Division, DivisionsUrl> {
  @override
  EntitiesState<Division, DivisionUrl, Division, DivisionsUrl> build() =>
      buildDefault();

  @override
  String getEntitiesUrl(DivisionsUrl url) => '/api/v1/divisions';

  @override
  String getEntityUrl(DivisionUrl url) => '/api/v1/divisions/${url.id.value}';

  @override
  Division decodeEntities(Map<String, dynamic> json) => Division.fromJson(json);

  @override
  Division decodeEntity(Map<String, dynamic> json) => Division.fromJson(json);
}
