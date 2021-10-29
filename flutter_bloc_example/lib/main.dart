import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_example/core/locator.dart';
import 'package:flutter_bloc_example/pages/product/list/ui/product_list_page.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
    () async {
      await setupLocator();
      runApp(MyApp());
    },
    (Object error, StackTrace stack) {
      _logger.e('Application', error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListPage(),
    );
  }
}
