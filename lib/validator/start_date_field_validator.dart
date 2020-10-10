class StartDateFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Start date field can\'t be empty' : null;
  }
}
