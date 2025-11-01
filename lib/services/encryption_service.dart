import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static String encrypt(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }
}
