import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

class COMData extends ChangeNotifier {
  int comNum;

  List<bool> _isOn = [];
  List<String> _baudRateText = [];
  List<String> _digitBitText = [];
  List<String> _parityBitTex = [];
  List<String> _stopBitText = [];
  List<bool> _isHex = [];
  List<bool> _isText = [];
  // List<String> _dataDisplayArea = [];
  // List<String> _sendDataArea = [];

  COMData(this.comNum) {
    for (int i = 0; i < comNum; i++) {
      _isOn.add(false);
      _baudRateText.add("9600");
      _digitBitText.add("8");
      _parityBitTex.add("8");
      _stopBitText.add("8");
      _isHex.add(false);
      _isText.add(false);
      // _dataDisplayArea.add("");
      // _sendDataArea.add("");
    }
  }

  List<bool> get isOn => _isOn;
  set isOn(List<bool> isOn) {
    _isOn = isOn;
    notifyListeners();
  }

  List<String> get baudRateText => _baudRateText;
  set baudRateText(List<String> baudRateText) {
    _baudRateText = baudRateText;
    notifyListeners();
  }

  List<String> get digitBitText => _digitBitText;
  set digitBitText(List<String> digitBitText) {
    _digitBitText = digitBitText;
    notifyListeners();
  }

  List<String> get parityBitTex => _parityBitTex;
  set parityBitTex(List<String> parityBitTex) {
    _parityBitTex = parityBitTex;
    notifyListeners();
  }

  List<String> get stopBitText => _stopBitText;
  set stopBitText(List<String> stopBitText) {
    _stopBitText = stopBitText;
    notifyListeners();
  }

  List<bool> get isHex => _isHex;
  set isHex(List<bool> isHex) {
    _isHex = isHex;
    notifyListeners();
  }

  List<bool> get isText => _isText;
  set isText(List<bool> isText) {
    _isText = isText;
    notifyListeners();
  }

  // List<String> get dataDisplayArea => _dataDisplayArea;
  // set dataDisplayArea(List<String> dataDisplayArea) {
  //   _dataDisplayArea = dataDisplayArea;
  //   notifyListeners();
  // }

  // List<String> get sendDataArea => _sendDataArea;
  // set sendDataArea(List<String> sendDataArea) {
  //   _sendDataArea = sendDataArea;
  //   notifyListeners();
  // }
}
