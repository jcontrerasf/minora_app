import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:minora/ble/ble_connection_handler.dart';
import 'package:simple_logger/simple_logger.dart';

class CommunicationHandler {
  SimpleLogger logger = SimpleLogger();
  late final BleConnectionHandler bleConnectionHandler;


  String deviceId = "";

  CommunicationHandler() {
    bleConnectionHandler = BleConnectionHandler();
  }

  void startScan(Function(DiscoveredDevice) scanDevice) {
    bleConnectionHandler.startBluetoothScan((discoveredDevice) => {scanDevice(discoveredDevice)});
  }

  Future<void> stopScan() async {
    await bleConnectionHandler.stopScan();
  }
  
}
