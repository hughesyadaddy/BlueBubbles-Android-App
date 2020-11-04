import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bluebubbles/helpers/contstants.dart';
import 'package:bluebubbles/helpers/themes.dart';
import 'package:bluebubbles/managers/settings_manager.dart';
import 'package:bluebubbles/repository/database.dart';
import 'package:bluebubbles/repository/helpers/db_converter.dart';
import 'package:bluebubbles/repository/models/config_entry.dart';
import 'package:bluebubbles/repository/models/fcm_data.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Settings {
  String guidAuthKey = "";
  String serverAddress = "";
  bool finishedSetup = false;
  int chunkSize = 500;
  bool autoDownload = true;
  bool onlyWifiDownload = false;
  bool autoOpenKeyboard = true;
  bool hideTextPreviews = false;
  bool showIncrementalSync = false;
  bool lowMemoryMode = false;
  int lastIncrementalSync = 0;
  // Map<String, dynamic> _lightColorTheme = {};
  // Map<String, dynamic> _darkColorTheme = {};
  Skins skin = Skins.IOS;

  Settings();

  factory Settings.fromConfigEntries(List<ConfigEntry> entries) {
    Settings settings = new Settings();
    for (ConfigEntry entry in entries) {
      if (entry.name == "serverAddress") {
        settings.serverAddress = entry.value;
      } else if (entry.name == "guidAuthKey") {
        settings.guidAuthKey = entry.value;
      } else if (entry.name == "finishedSetup") {
        settings.finishedSetup = entry.value;
      } else if (entry.name == "chunkSize") {
        settings.chunkSize = entry.value;
      } else if (entry.name == "autoOpenKeyboard") {
        settings.autoOpenKeyboard = entry.value;
      } else if (entry.name == "onlyWifiDownload") {
        settings.onlyWifiDownload = entry.value;
      } else if (entry.name == "hideTextPreviews") {
        settings.hideTextPreviews = entry.value;
      } else if (entry.name == "showIncrementalSync") {
        settings.showIncrementalSync = entry.value;
      } else if (entry.name == "lowMemoryMode") {
        settings.lowMemoryMode = entry.value;
      } else if (entry.name == "lastIncrementalSync") {
        settings.lastIncrementalSync = entry.value;
      }
    }
    return settings;
  }

  Future<Settings> save({Database database}) async {
    List<ConfigEntry> entries = this.toEntries();
    for (ConfigEntry entry in entries) {
      await entry.save("config", database: database);
    }
    return this;
  }

  static Future<Settings> getSettings() async {
    Database db = await DBProvider.db.database;

    List<Map<String, dynamic>> result = await db.query("config");
    if (result.length == 0) return new Settings();
    List<ConfigEntry> entries = [];
    for (Map<String, dynamic> setting in result) {
      entries.add(ConfigEntry.fromMap(setting));
    }
    return Settings.fromConfigEntries(entries);
  }

  List<ConfigEntry> toEntries() => [
        ConfigEntry(
            name: "serverAddress",
            value: this.serverAddress,
            type: this.serverAddress.runtimeType),
        ConfigEntry(
            name: "guidAuthKey",
            value: this.guidAuthKey,
            type: this.guidAuthKey.runtimeType),
        ConfigEntry(
            name: "finishedSetup",
            value: this.finishedSetup,
            type: this.finishedSetup.runtimeType),
        ConfigEntry(
            name: "chunkSize",
            value: this.chunkSize,
            type: this.chunkSize.runtimeType),
        ConfigEntry(
            name: "autoOpenKeyboard",
            value: this.autoOpenKeyboard,
            type: this.autoOpenKeyboard.runtimeType),
        ConfigEntry(
            name: "autoDownload",
            value: this.autoDownload,
            type: this.autoDownload.runtimeType),
        ConfigEntry(
            name: "onlyWifiDownload",
            value: this.onlyWifiDownload,
            type: this.onlyWifiDownload.runtimeType),
        ConfigEntry(
            name: "hideTextPreviews",
            value: this.hideTextPreviews,
            type: this.hideTextPreviews.runtimeType),
        ConfigEntry(
            name: "showIncrementalSync",
            value: this.showIncrementalSync,
            type: this.showIncrementalSync.runtimeType),
        ConfigEntry(
            name: "lowMemoryMode",
            value: this.lowMemoryMode,
            type: this.lowMemoryMode.runtimeType),
        ConfigEntry(
            name: "lastIncrementalSync",
            value: this.lastIncrementalSync,
            type: this.lastIncrementalSync.runtimeType),
      ];
}