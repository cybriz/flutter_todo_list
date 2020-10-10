import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todolist/validator/end_date_field_validator.dart';
import 'package:flutter_todolist/validator/start_date_field_validator.dart';
import 'package:flutter_todolist/validator/text_field_validator.dart';

void main() {
  test('empty text field returns error string', () {
    final result = TextFieldValidator.validate('');
    expect(result, 'Text field can\'t be empty');
  });

  test('non-empty  text field  returns null', () {
    final result = TextFieldValidator.validate('to-do');
    expect(result, null);
  });

  test('more than 50 character in text field returns error string', () {
    final result = TextFieldValidator.validate(
        'this is a super duper long long long long long long long long long long long long long text');
    expect(result, 'Text field can\'t be more than 50 words');
  });

  test('less than 50 character in text field password returns null', () {
    final result = TextFieldValidator.validate('this is a short text');
    expect(result, null);
  });

  test('empty start date returns error string', () {
    final result = StartDateFieldValidator.validate('');
    expect(result, 'Start date field can\'t be empty');
  });

  test('non-empty start date returns null', () {
    final result = StartDateFieldValidator.validate('hello');
    expect(result, null);
  });

  test('empty end date returns error string', () {
    final result = EndDateFieldValidator.validate('');
    expect(result, 'End date field can\'t be empty');
  });

  test('non-empty end date returns null', () {
    final result = EndDateFieldValidator.validate('123');
    expect(result, null);
  });
}
