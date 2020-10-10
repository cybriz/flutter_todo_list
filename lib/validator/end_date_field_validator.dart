class EndDateFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) return 'End date field can\'t be empty';
    return null;
  }
}
