// FIXME: SAMPLE CODE
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/entities_state.dart';
import 'package:native_app/store/base/notifiers/entities.dart';

import './models/division.dart';
import './models/division_input.dart';
import './models/division_url.dart';
import './models/divisions_url.dart';

typedef DivisionsState
    = EntitiesState<Division, DivisionUrl, Division, DivisionsUrl>;

class DivisionsNotifier extends EntitiesNotifier<Division, DivisionUrl,
    Division, DivisionsUrl, DivisionInput, DivisionInput> {
  DivisionsNotifier(super.ref, super.state);

  @override
  String getEntitiesUrl(DivisionsUrl url) => '/api/v1/divisions';

  @override
  String getEntityUrl(DivisionUrl url) => '/api/v1/divisions/${url.id.value}';

  @override
  Division decodeEntities(Map<String, dynamic> json) => Division.fromJson(json);

  @override
  Division decodeEntity(Map<String, dynamic> json) => Division.fromJson(json);
}

final divisionsProvider =
    StateNotifierProvider<DivisionsNotifier, DivisionsState>(
        (ref) => DivisionsNotifier(ref, const EntitiesState()));
