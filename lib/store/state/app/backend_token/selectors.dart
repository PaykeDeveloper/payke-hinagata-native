import './notifier.dart';

final backendTokenSelector =
    backendTokenStateProvider.select((state) => state.value);

final backendTokenHasValueSelector =
    backendTokenStateProvider.select((state) => state.hasValue);
