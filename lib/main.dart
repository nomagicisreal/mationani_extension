import 'package:datter/datter.dart';
import 'package:flutter/material.dart';

void main(List<String> arguments) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _toggle = false;

  void _onPressed() {
    setState(() => _toggle = !_toggle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 200,
          child: ColoredBox(color: context.colorScheme.primary),
        ),
      ),

      appBar: AppBar(
        backgroundColor: context.colorScheme.inversePrimary,
        title: Text('hell'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressed,
        child: Text('$_toggle'[0].toUpperCase()),
      ),
    );
  }
}
