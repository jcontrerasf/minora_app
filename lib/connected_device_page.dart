import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:minora/ble/communication_handler.dart';
import 'package:simple_logger/simple_logger.dart';

class ConnectedDevicePage extends StatefulWidget {
  const ConnectedDevicePage(
      {super.key, required this.device, required this.handler});

  final DiscoveredDevice device;
  final CommunicationHandler? handler;

  @override
  State<ConnectedDevicePage> createState() => _ConnectedDevicePageState();
}

class _ConnectedDevicePageState extends State<ConnectedDevicePage> {
  bool isConnected = false;
  SimpleLogger logger = SimpleLogger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.handler?.disconnectDevice();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          if(!isConnected){
            return const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            return const Column(
              children: [
                Text("Conectado"),
                Text("data 2")
              ],
            );
          }
        }),
    );
  }

  @override
  void initState() {
    super.initState();
    connectToDevice(widget.device);
  }

  Future<void> connectToDevice(DiscoveredDevice selectedDevice) async {
    logger.warning("Conectando");
    widget.handler?.connectToDevice(selectedDevice, (isConnected) {
      this.isConnected = isConnected;
      if (isConnected) {
        // connectedDeviceDetails = "Connected Device Details\n\n$selectedDevice";
        logger.info("Conectado");
      } else {
        // connectedDeviceDetails = "";
        logger.info("Error al intentar conectar");
      }
      setState(() {
        // connectedDeviceDetails;
        isConnected;
      });
    });
  }
}
