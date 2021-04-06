extension ExtendedList<T> on List<T> {
  T? firstOrNull() => isEmpty ? null : first;

  T? lastOrNull() => isEmpty ? null : last;
}
