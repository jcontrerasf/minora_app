import 'package:flutter/material.dart';

class ConnectedDevicePage extends StatelessWidget {
const ConnectedDevicePage({ super.key });


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispositivo"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}