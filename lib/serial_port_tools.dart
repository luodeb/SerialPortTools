/*
 * Based on serial_port_tools (https://sigrok.org/wiki/serial_port_tools).
 *
 * Copyright (C) 2010-2012 Bert Vermeulen <bert@biot.com>
 * Copyright (C) 2010-2015 Uwe Hermann <uwe@hermann-uwe.de>
 * Copyright (C) 2013-2015 Martin Ling <martin-serial_port_tools@earth.li>
 * Copyright (C) 2013 Matthias Heidbrink <m-sigrok@heidbrink.biz>
 * Copyright (C) 2014 Aurelien Jacobs <aurel@gnuage.org>
 * Copyright (C) 2020 J-P Nurmi <jpnurmi@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/// # Introduction
///
/// Serial Port for Dart is based on
/// [serial_port_tools](https://sigrok.org/wiki/serial_port_tools), which is a minimal
/// C-library created by the [sigrok](http://sigrok.org/) projects, and released
/// under the LGPL3+ license.
///
/// # Import
///
///     import 'serial_port/serial_port.dart'
///
/// # Getting Started
///
/// - [SerialPort]
///   - obtaining a list of serial ports on the system
///   - opening, closing and getting information about ports
///   - signals, modem control lines, breaks, etc.
///   - low-level reading and writing data
/// - [SerialPortConfig]
///   - baud rate, parity, etc.
/// - [SerialPortReader]
///   - high-level data stream for reading data asynchronously
///
/// # Debugging
///
/// The library can output extensive tracing and debugging information. The
/// simplest way to use this is to set an environment variable
/// `serial_port_tools_DEBUG` to any value; messages will then be output to the
/// standard error stream.
///
/// No guarantees are made about the content of the debug output; it is chosen
/// to suit the needs of the developers and may change between releases.
library serial_port_tools;

import 'src/port.dart';
// import 'socket/serverSocket.dart' as serverSocket;
import 'socket/serverSocket.dart';

export 'src/config.dart' show SerialPortConfig;
export 'src/enums.dart';
export 'src/error.dart';
export 'src/port.dart' show SerialPort;
export 'src/reader.dart' show SerialPortReader;

// void socketFork() async {
//   startServer();
// }

// void comFork() async {}

void serverMain() {
// <<<<<<< HEAD
  startServer("192.168.255.1", 8080);
// =======
  // startServer('127.0.0.1', 4041);
// >>>>>>> cce0715749a2699da705528958e57100490ed5d4
  // socketFork();
  // comFork();
  // GlobalSerialPort.port = SerialPort("COM10");
  // print(GlobalSerialPort.port.config.baudRate);
}
