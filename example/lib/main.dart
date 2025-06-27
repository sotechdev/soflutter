import 'package:flutter/material.dart';
import 'pages/async_controller_builder_page.dart';
import 'pages/async_controller_when_page.dart';
import 'pages/controller_builder_page.dart';
import 'pages/controller_consumer_page.dart';
import 'pages/multi_controller_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Builders Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BuilderSelectionPage(),
    );
  }
}

class BuilderSelectionPage extends StatelessWidget {
  const BuilderSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Builder to Test')),
      body: ListView(
        children: [
          _buildListTile(
            context,
            title: 'ControllerBuilder',
            subtitle: 'Builder básico para Controller',
            page: ControllerBuilderPage(),
          ),
          _buildListTile(
            context,
            title: 'ControllerConsumer',
            subtitle: 'Consumer com acesso à Controller',
            page: ControllerConsumerPage(),
          ),
          _buildListTile(
            context,
            title: 'AsyncControllerBuilder',
            subtitle: 'Builder com widgets específicos',
            page: AsyncControllerBuilderPage(),
          ),
          _buildListTile(
            context,
            title: 'AsyncControllerWhenBuilder',
            subtitle: 'Builder com método when',
            page: AsyncControllerWhenPage(),
          ),
          _buildListTile(
            context,
            title: 'MultiControllerBuilder',
            subtitle: 'Builder para múltiplas Controllers',
            page: MultiControllerPage(),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, {
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}