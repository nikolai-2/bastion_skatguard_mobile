const String baseUrl = String.fromEnvironment('BASE_URL',
    defaultValue: '192.168.43.184:3000');
const String scheme = String.fromEnvironment('SCHEME', defaultValue: 'http');

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
