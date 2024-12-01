import '../models/connection.dart';

class ConnectionsService {
  Future<List<Connection>> getConnections() async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      Connection(
          id: '1',
          name: 'John Doe',
          imageUrl: 'assets/images/john.jpg',
          isOnline: true),
      Connection(
          id: '2',
          name: 'Jane Smith',
          imageUrl: 'assets/images/jane.jpg',
          isOnline: true),
      Connection(
          id: '3',
          name: 'Bob Johnson',
          imageUrl: 'assets/images/bob.jpg',
          isOnline: false),
      Connection(
          id: '4',
          name: 'Alice Brown',
          imageUrl: 'assets/images/alice.jpg',
          isOnline: true),
      Connection(
          id: '5',
          name: 'Charlie Davis',
          imageUrl: 'assets/images/charlie.jpg',
          isOnline: false),
    ];
  }
}
