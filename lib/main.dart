import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import './database/database.dart';
import './services/router.dart' as route;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final kiwi.Container _container = kiwi.Container();
  final AppDatabase _appDatabase = AppDatabase();
  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  @override
  void initState() {
    _container.registerSingleton((c) => _appDatabase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFFCAF00, color);

    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(
          value: _appDatabase,
        ),
      ],
      child: MaterialApp(
        title: 'flutter_todolist',
        theme: ThemeData(
          primarySwatch: colorCustom,
          accentColor: const Color(0xFFE94818),
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
        ),
        onGenerateRoute: route.Router.generateRoute,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
