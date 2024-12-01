import 'package:flutter/material.dart';
import 'package:mindaigle/core/config/api_config.dart';

class ConnectionTestPage extends StatefulWidget {
  const ConnectionTestPage({super.key});

  @override
  _ConnectionTestPageState createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  String _status = 'Not tested';
  bool _isTesting = false;
  String _deviceType = '';

  @override
  void initState() {
    super.initState();
    _initializeDeviceInfo();
  }

  Future<void> _initializeDeviceInfo() async {
    setState(() {
      _deviceType = ApiConfig.isEmulator ? 'Emulator' : 'Physical Device';
    });
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _status = 'Testing...';
    });

    try {
      final isConnected = await ApiConfig.testConnection();
      setState(() {
        _status = isConnected
            ? 'Connection successful!\nServer: ${ApiConfig.getBaseUrl()}'
            : 'Connection failed.\nServer: ${ApiConfig.getBaseUrl()}\nPlease check your connection settings.';
      });
    } catch (e) {
      setState(() {
        _status = 'Connection error:\n$e\nServer: ${ApiConfig.getBaseUrl()}';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device Type: $_deviceType',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Server URL: ${ApiConfig.getBaseUrl()}',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isTesting ? null : _testConnection,
              child: Text(_isTesting ? 'Testing...' : 'Test Connection'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Connection Status:',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_status,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
