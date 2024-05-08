import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> _devices = [];

  Future<List<BluetoothDevice>> scanDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      // Start scanning for Bluetooth devices
      await flutterBlue.startScan(timeout: const Duration(seconds: 4));

      // Listen for discovered devices
      flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devices.contains(result.device)) {
            devices.add(result.device);
          }
        }
      });

      // Wait for the scan to complete
      await Future.delayed(const Duration(seconds: 4));

      // Stop scanning
      await flutterBlue.stopScan();
    } catch (e) {
      print('Error scanning for devices: $e');
    }

    return devices;
  }

  Future<void> _scanDevices() async {
    List<BluetoothDevice> devices = await scanDevices();
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("minora"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_devices[index].name),
            subtitle: Text(_devices[index].id.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scanDevices(),
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
