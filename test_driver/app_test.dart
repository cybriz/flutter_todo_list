import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_todolist/widgets/twelveFormatTime.dart';
import 'package:test/test.dart';

void main() {
  group('flutter driver to-do list', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    final floatingButton = find.byType('FloatingActionButton');
    final textfield = find.byValueKey('text');
    final startDate = find.byValueKey('startDate');
    final endDate = find.byValueKey('endDate');
    final create = find.byValueKey('create');
    var getHour = DateTime.now().hour + 1;
    var hour = TwelveFormatTime.setHour(getHour);
    final card = find.byValueKey('card');
    final checkbox = find.byValueKey('checkbox');

    test('create To-Do list', () async {
      //add To-do List
      await driver.tap(floatingButton);
      await driver.tap(textfield);
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(textfield);
      await Future.delayed(Duration(seconds: 1));
      await driver.enterText("Add etiqa");
      await Future.delayed(Duration(seconds: 1));
      await driver.waitFor(startDate);
      await driver.tap(startDate);
      await driver.tap(find.text('15'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text(hour.toString()));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(endDate);
      await driver.tap(find.text('16'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text(hour.toString()));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(create);

      //edit To-do List
      await driver.tap(card);
      await driver.tap(textfield);
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(textfield);
      await Future.delayed(Duration(seconds: 1));
      await driver.enterText("Edit etiqa");
      await Future.delayed(Duration(seconds: 1));
      await driver.waitFor(startDate);
      await driver.tap(startDate);
      await driver.tap(find.text('27'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text(hour.toString()));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(endDate);
      await driver.tap(find.text('30'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text(hour.toString()));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('OK'));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(create);

      //checkbox
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(checkbox);
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(checkbox);

      //delete
      await Future.delayed(Duration(seconds: 1));
      await driver.scroll(card, -400, 0, Duration(milliseconds: 500));
      await Future.delayed(Duration(seconds: 1));
      await driver.tap(find.text('Undo'));
    });
  });
}
