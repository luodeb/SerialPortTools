class SerialPortData {
  SerialPortData({
    this.name = "",
    this.description = "",
    this.baud = 115200,
    this.stopBit = 8,
    this.parity = 0,
    this.check = 0,
    this.status = false,
  });

  String name;
  String description;
  int baud;
  int stopBit;
  int parity;
  int check;
  bool status;


  static List<SerialPortData> serialPortDataList = <SerialPortData>[
    SerialPortData(
      name: "COM1",
      baud: 115200,
      stopBit: 8,
      parity: 0,
      check: 0,
      status: false,
    ),
  ];

  static List<int> baudList = [300, 1200, 2400, 9600, 19200, 38400, 115200];
  static List<int> stopBitList = [0, 2, 4, 8];
  static List<int> parityList = [0, 2, 4, 8];
  static List<int> checkList = [0, 2, 4, 8];
}

List<SerialPortData> myportdataList = [];
bool myportReflash=false;