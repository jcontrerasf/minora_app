import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:minora/ble/communication_handler.dart';
import 'package:minora/text_input.dart';
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
            // widget.handler?.disconnectDevice();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          if(!isConnected){
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 8.0,
                strokeCap: StrokeCap.round,              
              ),
            );
          }else{
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Conectado"),
                  TextInput(text: "WiFi SSID",),
                  TextInput(text: "WiFi Password",)
                ],
              ),
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
