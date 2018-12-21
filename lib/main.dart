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

Future<Null> androidUpgrade() async {
  /*
  String db_path = "/data/data/com.alexey.test/databases/saints.sqlite";
  File f = File.fromUri(Uri.file(db_path));

  if (await f.exists()) await f.delete();

  final platform = const MethodChannel('com.alexey.test/saints');
  String downloads = await platform.invokeMethod('getDownloadsDir');

  final dir = Directory(downloads + 'images');

  if (await dir.exists()) await dir.delete(recursive: true);
  */
}

Future<Null> iosUpgrade() async {
  Directory dir = await getApplicationDocumentsDirectory();

  var f = File.fromUri(Uri.file('${dir.path}/saints-icons-300px.zip'));
  var iconsDir = Directory(dir.path + '/saints-icons-300px');

  if (await f.exists()) await f.delete();
  if (await iconsDir.exists()) await iconsDir.delete(recursive: true);

  f = File.fromUri(Uri.file('${dir.path}/icons.zip'));
  iconsDir = Directory(dir.path + '/icons');

  if (await f.exists()) await f.delete();
  if (await iconsDir.exists()) await iconsDir.delete(recursive: true);
}

Future<Null> main() async {
  G.prefs = await SharedPreferences.getInstance();

  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = documentsDirectory.path + "/saints.sqlite";

  if (!G.prefs.getKeys().contains('version_4_5')) {
    await G.prefs.clear();

    if (Platform.isAndroid)
      await androidUpgrade();
    else if (Platform.isIOS) await iosUpgrade();

    await copyDatabase(to: path);

    G.prefs.setBool('version_4_5', true);
  }

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

