import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setPathUrlStrategy();
  runApp(const App());
}
