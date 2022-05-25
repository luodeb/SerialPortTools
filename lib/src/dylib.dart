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

import 'dart:ffi' as ffi;

import 'package:serial_port_tools/src/bindings.dart';
import 'package:dylib/dylib.dart';

serial_port_tools? _dylib;
serial_port_tools get dylib {
  return _dylib ??= serial_port_tools(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'serialport',
      path: 'lib/dll',
      dartDefine: 'serial_port_tools_PATH',
      environmentVariable: 'serial_port_tools_PATH',
    ),
  ));
}
