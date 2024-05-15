//Basado en: https://github.com/janaka92/flutter_bluetooth

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:minora/ble/communication_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_logger/simple_logger.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      )),
      // color: Theme.of(context).colorScheme.primary,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  SimpleLogger logger = SimpleLogger();
  CommunicationHandler? communicationHandler;
  bool isScanStarted = false;
  bool isConnected = false;
  List<DiscoveredDevice> discoveredDevices = List<DiscoveredDevice>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("minora"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body:ListView.builder(
        itemCount: discoveredDevices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(discoveredDevices[index].name),
            subtitle: Text(discoveredDevices[index].id.toString()),
            trailing: ElevatedButton(
              onPressed: () {
                DiscoveredDevice selectedDevice = discoveredDevices[index];
                connectToDevice(selectedDevice);
              },
              child: const Icon(Icons.settings_bluetooth_rounded),
            ),
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => isScanStarted ? stopScan() : startScan(),
        child: Icon(isScanStarted ? Icons.stop : Icons.refresh_rounded),
      ),
    );
  }

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.bluetoothAdvertise,
    ].request();

    logger.info("PermissionStatus -- $statuses");
  }

  void startScan() {
    communicationHandler ??= CommunicationHandler();
    communicationHandler?.startScan((scanDevice) {
      logger.info("Scan device: ${scanDevice.name}");
      if (discoveredDevices.firstWhereOrNull((val) => val.id == scanDevice.id) == null) {
        logger.info("Added new device to list: ${scanDevice.name}");
        setState(() {
          discoveredDevices.add(scanDevice);
        });
      }
    });

    setState(() {
      isScanStarted = true;
      discoveredDevices.clear();
    });
  }

  Future<void> stopScan() async {
    await communicationHandler?.stopScan();
    setState(() {
      isScanStarted = false;
    });
  }

  Future<void> connectToDevice(DiscoveredDevice selectedDevice) async {
    await stopScan();
    communicationHandler?.connectToDevice(selectedDevice, (isConnected) {
      this.isConnected = isConnected;
      // if (isConnected) {
      //   connectedDeviceDetails = "Connected Device Details\n\n$selectedDevice";
      // } else {
      //   connectedDeviceDetails = "";
      // }
      // setState(() {
      //   connectedDeviceDetails;
      // });
    });
  }
}