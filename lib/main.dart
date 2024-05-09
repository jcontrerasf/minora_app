import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:minora/controllers/ble_controller.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("minora"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: GetBuilder<BLEController>(
          init: BLEController(),
          builder: (BLEController controller) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<List<ScanResult>>(
                      stream: controller.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return ListTile(
                              title: Text(data.device.name),
                              subtitle: Text(data.device.id.id),
                            );
                          });
                        } else {
                          return const Center(
                            child: Text("No se encontraron"),
                          );
                        }
                      }),
                  ElevatedButton(onPressed: () => controller.scanDevices(), child: const Text("Escanear"))
                ],
              ),
            );
          },
        ));
  }
}

// ListView.builder(
//         itemCount: _devices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_devices[index].name),
//             subtitle: Text(_devices[index].id.toString()),
//           );
//         },
//       ),
// floatingActionButton: FloatingActionButton(
//         onPressed: () => _scanDevices(),
//         child: const Icon(Icons.refresh_outlined),
//       ),