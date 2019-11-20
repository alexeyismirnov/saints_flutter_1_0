import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';

import 'globals.dart' as G;
import 'db.dart';
import 'restart_widget.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  G.prefs = await SharedPreferences.getInstance();

  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = documentsDirectory.path + "/saints.sqlite";
  await copyDatabase(to: path);

  G.db = await openDatabase(path);

  if (!G.prefs.getKeys().contains('bgcolor')) {
    G.prefs.setInt('bgcolor', 0);
  }

  if (!G.prefs.getKeys().contains('fontSize')) {
    G.prefs.setDouble('fontSize', 20.0);
  }

  if (!G.prefs.getKeys().contains('favs')) {
    G.prefs.setStringList('favs', []);
  }

  if (!G.prefs.getKeys().contains('search')) {
    G.prefs.setString('search', '');
  }

  runApp(RestartWidget());
}

