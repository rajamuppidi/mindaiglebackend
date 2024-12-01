// // lib/features/wearable/views/widgets/device_status_card.dart

// import 'package:flutter/material.dart';

// class DeviceStatusCard extends StatelessWidget {
//   final String status;
//   final int batteryLevel;

//   const DeviceStatusCard({
//     super.key,
//     required this.status,
//     required this.batteryLevel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isConnected = status == 'Connected';

//     return Card(
//       margin: const EdgeInsets.all(16.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Icon(
//               Icons.watch,
//               color: isConnected
//                   ? theme.colorScheme.primary
//                   : theme.colorScheme.error,
//               size: 48,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Device Status",
//                     style: theme.textTheme.titleLarge,
//                   ),
//                   Text(
//                     status,
//                     style: TextStyle(
//                       color: isConnected
//                           ? Colors.green.shade400
//                           : theme.colorScheme.error,
//                     ),
//                   ),
//                   if (isConnected)
//                     Text(
//                       "Battery: $batteryLevel%",
//                       style: TextStyle(color: theme.colorScheme.onSurface),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/features/wearable/widgets/device_status_card.dart

// lib/features/wearable/widgets/device_status_card.dart

import 'package:flutter/material.dart';

class DeviceStatusCard extends StatelessWidget {
  final String status;
  final int batteryLevel;

  const DeviceStatusCard({
    super.key,
    required this.status,
    required this.batteryLevel,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'connected':
        return Colors.green;
      case 'basic tracking':
        return Colors.orange;
      case 'disconnected':
      case 'permission denied':
      case 'error connecting':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'connected':
        return Icons.check_circle;
      case 'basic tracking':
        return Icons.info;
      case 'disconnected':
        return Icons.link_off;
      case 'permission denied':
        return Icons.block;
      case 'error connecting':
        return Icons.error;
      default:
        return Icons.device_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.battery_std,
                      color: batteryLevel > 20 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$batteryLevel%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
