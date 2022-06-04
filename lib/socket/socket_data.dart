class SerialPortData {
  SerialPortData({
    this.name = "",
    this.baud = 115200,
    this.stopBit = 8,
    this.parity = 0,
    this.check = 0,
  });

  String name;
  int baud;
  int stopBit;
  int parity;
  int check;

  static SerialPortData serialPortData = SerialPortData(
    name: "COM1",
    baud: 115200,
    stopBit: 8,
    parity: 0,
    check: 0,
  );

  static List<int> baudList  = [300,1200,2400,9600,19200,38400,115200];
}

