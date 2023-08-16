// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:io';

import 'package:dart_telegram_bot/dart_telegram_bot.dart';
import 'package:dart_telegram_bot/telegram_entities.dart' hide File;
import 'package:oab_de_bolso_flutter/src/shared/data/entities/env.dart';
import 'package:yaml/yaml.dart';

void main() {
  _sendApkToTelegram();
}

String _returnAppVersion(String yml) {
  Map yaml = loadYaml(yml);
  return yaml['version'].toString().split('+').first;
}

void _sendApkToTelegram() async {
  try {
    print('Starting to send apk to Telegram...');
    Bot telegramBot = Bot(
      token: Env.telegramBotToken.toString(),
    );

    File file = File('build/app/outputs/flutter-apk/app-dev-release.apk');
    Uint8List apkBytes = file.readAsBytesSync();

    File pubspecYml = File('pubspec.yaml');
    late String appVersion = '';

    String pubspecYmlString = await pubspecYml.readAsString();
    appVersion = _returnAppVersion(pubspecYmlString);

    telegramBot
        .sendDocument(
          ChatID(Env.telegramChatId.toInt()),
          HttpFile.fromBytes(
            '$appVersion-app-oab.apk',
            apkBytes,
          ),
        )
        .then(
          (value) => print('Completed uploading apk to Telegram!'),
        );
  } catch (e) {
    print('Error when trying to send apk to Telegram: ${e.toString()}');
  }
}
