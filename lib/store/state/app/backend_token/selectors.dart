import './notifier.dart';

final backendTokenSelector =
    backendTokenStateProvider.select((state) => state.value);

final backendTokenHasValueLoSelector =
backendTokenStateProvider.select((state) => state.hasValue);
