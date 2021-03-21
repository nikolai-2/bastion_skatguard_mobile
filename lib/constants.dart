const String baseUrl = String.fromEnvironment('BASE_URL',
    defaultValue: 'user152879324-7n5ib4gg.wormhole.vk-apps.com');
const String scheme = String.fromEnvironment('SCHEME', defaultValue: 'https');

String weekdayName(int weekday) {
  switch (weekday) {
    case 1:
      return 'Пн';
    case 2:
      return 'Вт';
    case 3:
      return 'Ср';
    case 4:
      return 'Чт';
    case 5:
      return 'Пт';
    case 6:
      return 'Сб';
    case 7:
      return 'Вс';
    default:
      throw Exception('weekday must be > 0 && < 8');
  }
}
