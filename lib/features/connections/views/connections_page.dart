import 'package:flutter/material.dart';
import '../models/connection.dart';
import '../widgets/connection_circle.dart';
import 'package:mindaigle/features/profile/controllers/profile_controller.dart';

class ConnectionsPage extends StatefulWidget {
  final bool showAppBar;

  const ConnectionsPage({super.key, this.showAppBar = true});

  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  List<Connection> connections = [];
  final ProfileController _profileController = ProfileController();
  String profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchConnections();
    _fetchProfilePicture();
  }

  void _fetchConnections() {
    // Simulating API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        connections = [
          Connection(
              id: '1',
              name: 'John Doe',
              imageUrl: 'https://picsum.photos/200?random=1',
              isOnline: true),
          Connection(
              id: '2',
              name: 'Jane Smith',
              imageUrl: 'https://picsum.photos/200?random=2',
              isOnline: false),
          Connection(
              id: '3',
              name: 'Bob Johnson',
              imageUrl: 'https://picsum.photos/200?random=3',
              isOnline: true),
          Connection(
              id: '4',
              name: 'Alice Brown',
              imageUrl: 'https://picsum.photos/200?random=4',
              isOnline: false),
          Connection(
              id: '5',
              name: 'Charlie Davis',
              imageUrl: 'https://picsum.photos/200?random=5',
              isOnline: true),
        ];
      });
    });
  }

  Future<void> _fetchProfilePicture() async {
    try {
      await _profileController.fetchUserData();
      setState(() {
        profilePictureUrl = _profileController.photoURL ?? '';
      });
      print('Fetched profile picture URL: $profilePictureUrl'); // Debug print
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Connections'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Connect with your Circle of Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ConnectionCircleView(
              connections: connections,
              profilePictureUrl: profilePictureUrl,
            ),
          ),
        ],
      ),
    );
  }
}
