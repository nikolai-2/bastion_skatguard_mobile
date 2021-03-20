String? verifyEmail(String? email) {
  if (email == null) return null;
  if (email == 'test') return null;
  final splitted = email.split('@');
  if (splitted.length == 2 &&
      splitted[0].isNotEmpty &&
      splitted[1].isNotEmpty) {
    return null;
  }
  return 'Неправильный E-Mail';
}

String? verifyPassword(String? password) {
  if (password == null) return null;
  return password.length > 2 ? null : 'Пароль должен содержать больше символов';
}
