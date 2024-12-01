import 'package:get/get.dart';
import '../models/connection.dart';

class ConnectionsController extends GetxController {
  final RxList<Connection> connections = <Connection>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConnections();
  }

  void fetchConnections() {
    final List<Connection> fetchedConnections = [
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
    connections.assignAll(fetchedConnections);
  }
}
