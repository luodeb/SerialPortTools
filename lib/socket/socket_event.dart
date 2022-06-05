import 'dart:async';
import 'package:event_bus/event_bus.dart';

class SocketEvent {
  static EventBus event = EventBus();
}

class ScanFlush {
  // String Data;
  // ScanFlush(this.Data);
}

class MessageEvent {
  String data;
  MessageEvent(this.data);
}
