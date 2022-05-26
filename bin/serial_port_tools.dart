import 'dart:io';
// ignore: unused_import
import 'dart:convert';
import 'package:serial_port_tools/serial_port_tools.dart';

// ignore_for_file: avoid_print

void main() {
  serverMain();
  // print('Available ports:');
  // var i = 0;
  // for (final name in SerialPort.availablePorts) {
  //   final sp = SerialPort(name);
  //   print('${++i}) $name');
  //   print('\tDescription: ${sp.description}');
  //   print('\tManufacturer: ${sp.manufacturer}');
  //   print('\tSerial Number: ${sp.serialNumber}');
  //   // print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
  //   // print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
  //   sp.dispose();
  // }
  // const name = "COM10";
  // // print(name);
  // final port = SerialPort(name);
  // port.config.baudRate = 115200;
  // if (!port.openReadWrite()) {
  //   print(SerialPort.lastError);
  //   exit(-1);
  // }

  // print(port.config.baudRate);
  // final reader = SerialPortReader(port);
  // reader.stream.listen((data) {
  //   final String str = String.fromCharCodes(data);
  //   port.write(data);
  //   // port.bytesToWrite;
  //   print('received: $str');
  // });
}
