class TextFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) return 'Text field can\'t be empty';
    if (value.length > 50) return 'Text field can\'t be more than 50 words';
    return null;
  }
}
