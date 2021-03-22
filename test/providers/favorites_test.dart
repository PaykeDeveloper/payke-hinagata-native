import 'package:flutter_test/flutter_test.dart';
import 'package:hinagata/providers/favorites.dart';

void main() {
  group('App Provider Tests', () {
    final favorites = Favorites();

    test('A new item should be added', () {
      const number = 35;
      favorites.add(number);
      expect(favorites.items.contains(number), true);
    });

    test('An item should be removed', () {
      const number = 45;
      favorites.add(number);
      expect(favorites.items.contains(number), true);
      favorites.remove(number);
      expect(favorites.items.contains(number), false);
    });
  });
}
