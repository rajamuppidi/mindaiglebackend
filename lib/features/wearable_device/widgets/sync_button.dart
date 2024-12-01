// // lib/features/wearable/views/widgets/sync_button.dart

// import 'package:flutter/material.dart';

// class SyncButton extends StatelessWidget {
//   final VoidCallback onSync;
//   final bool isSyncing;

//   const SyncButton({
//     super.key,
//     required this.onSync,
//     this.isSyncing = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: ElevatedButton.icon(
//         onPressed: isSyncing ? null : onSync,
//         icon: isSyncing
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : const Icon(Icons.sync),
//         label: Text(isSyncing ? "Syncing..." : "Sync Device Data"),
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         ),
//       ),
//     );
//   }
// }

// lib/features/wearable/widgets/sync_button.dart (continued)

import 'package:flutter/material.dart';

class SyncButton extends StatelessWidget {
  final VoidCallback onSync;
  final bool isSyncing;

  const SyncButton({
    super.key,
    required this.onSync,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: isSyncing ? null : onSync,
        icon: isSyncing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.sync),
        label: Text(isSyncing ? 'Syncing...' : 'Sync Data'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(200, 48),
        ),
      ),
    );
  }
}
