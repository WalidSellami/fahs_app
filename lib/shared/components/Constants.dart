import 'dart:io';
import 'dart:isolate';

String getOs() => Platform.operatingSystem;

ReceivePort? receivePort;
