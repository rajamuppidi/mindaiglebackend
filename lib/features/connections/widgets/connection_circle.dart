import 'package:flutter/material.dart';
import '../models/connection.dart';
import 'dart:math' as math;

class ConnectionCircleView extends StatefulWidget {
  final List<Connection> connections;
  final String profilePictureUrl;

  const ConnectionCircleView({
    super.key,
    required this.connections,
    required this.profilePictureUrl,
  });

  @override
  _ConnectionCircleViewState createState() => _ConnectionCircleViewState();
}

class _ConnectionCircleViewState extends State<ConnectionCircleView> {
  bool _useDefaultImage = false;

  @override
  void initState() {
    super.initState();
    _useDefaultImage = widget.profilePictureUrl.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final centerY = constraints.maxHeight / 2;
        final maxRadius =
            math.min(constraints.maxWidth, constraints.maxHeight) / 2;

        const orbitCount = 3;

        return Stack(
          children: [
            // Orbital paths
            ...List.generate(orbitCount, (index) {
              final radius = maxRadius * (0.4 + (index * 0.2));
              return Positioned(
                left: centerX - radius,
                top: centerY - radius,
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 1),
                  ),
                ),
              );
            }),
            // Center avatar (user)
            Positioned(
              left: centerX - 30,
              top: centerY - 30,
              child: _buildUserAvatar(),
            ),
            // Connections
            ...List.generate(math.min(widget.connections.length, 6), (index) {
              final orbitIndex = index ~/ 2;
              final angleOffset = (index % 2) * math.pi;
              final angle = angleOffset + (orbitIndex * (math.pi / 3));
              final radius = maxRadius * (0.4 + (orbitIndex * 0.2));
              final x = centerX + radius * math.cos(angle);
              final y = centerY + radius * math.sin(angle);

              return Positioned(
                left: x - 30,
                top: y - 30,
                child: ConnectionAvatar(connection: widget.connections[index]),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: _useDefaultImage
            ? const AssetImage('assets/images/default_profile_picture.png')
            : NetworkImage(widget.profilePictureUrl) as ImageProvider,
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading profile image: $exception');
          setState(() {
            _useDefaultImage = true;
          });
        },
      ),
    );
  }
}

class ConnectionAvatar extends StatelessWidget {
  final Connection connection;

  const ConnectionAvatar({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(connection.imageUrl),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: connection.isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
