import 'package:flutter/material.dart';
import 'package:flutter_todolist/common/styles.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import './database/database.dart';
import './services/router.dart' as route;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final kiwi.Container _container = kiwi.Container();
  final AppDatabase _appDatabase = AppDatabase();

  @override
  void initState() {
    _container.registerSingleton((c) => _appDatabase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFFCAF00, kCustomColors);

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
