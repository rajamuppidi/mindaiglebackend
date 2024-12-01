// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mindaigle/features/wearable_device/controller/Health_Data_Controller.dart';
// import 'package:mindaigle/features/wearable_device/widgets/device_status_card.dart';
// import 'package:mindaigle/features/wearable_device/widgets/health_metric_card.dart';
// import 'package:mindaigle/features/wearable_device/widgets/sync_button.dart';
// import 'package:mindaigle/features/self-report/views/self_report_page.dart';

// class WearableDevicePage extends StatelessWidget {
//   const WearableDevicePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => HealthDataController()..initializeHealth(),
//       child: const WearableDeviceView(),
//     );
//   }
// }

// class WearableDeviceView extends StatelessWidget {
//   const WearableDeviceView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final controller = context.watch<HealthDataController>();
//     final metrics = controller.healthMetrics;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wearable Device"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: IconButton.filledTonal(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const SelfReportPage(),
//                 ),
//               ),
//               icon: const Icon(Icons.edit_note),
//               tooltip: 'Self Report',
//             ),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: controller.manualSync,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               _buildHeader(context),
//               if (controller.isLoading)
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//               else if (controller.errorMessage != null)
//                 _buildErrorMessage(context, controller.errorMessage!)
//               else ...[
//                 DeviceStatusCard(
//                   status: controller.deviceStatus,
//                   batteryLevel: controller.batteryLevel,
//                 ),
//                 SyncButton(
//                   onSync: controller.manualSync,
//                   isSyncing: controller.isLoading,
//                 ),
//                 if (metrics != null) ...[
//                   if (!controller.hasHeartRate &&
//                       !controller.hasTemperature &&
//                       !controller.hasSleep)
//                     _buildNoDataMessage(context)
//                   else ...[
//                     HealthMetricCard(
//                       title: "Walking",
//                       value: "${metrics.steps.toStringAsFixed(0)} Steps",
//                       icon: Icons.directions_walk,
//                       color: Colors.green.shade400,
//                     ),
//                     if (metrics.heartRate != null)
//                       HealthMetricCard(
//                         title: "Heart Rate",
//                         value: "${metrics.heartRate!.toStringAsFixed(0)} bpm",
//                         icon: Icons.favorite,
//                         color: Colors.red.shade400,
//                       ),
//                     if (metrics.temperature != null)
//                       HealthMetricCard(
//                         title: "Temperature",
//                         value: "${metrics.temperature!.toStringAsFixed(1)} °F",
//                         icon: Icons.thermostat_outlined,
//                         color: Colors.orange.shade400,
//                       ),
//                     if (metrics.sleepHours != null)
//                       HealthMetricCard(
//                         title: "Sleep",
//                         value:
//                             "${metrics.sleepHours!.toStringAsFixed(1)} Hours",
//                         icon: Icons.bedtime,
//                         color: Colors.purple.shade300,
//                       ),
//                   ],
//                   if (!controller.hasTemperature ||
//                       !controller.hasHeartRate ||
//                       !controller.hasSleep)
//                     _buildAvailabilityMessage(context),
//                 ],
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorMessage(BuildContext context, String message) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 48),
//               const SizedBox(height: 16),
//               Text(
//                 message,
//                 style: Theme.of(context).textTheme.bodyLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () =>
//                     context.read<HealthDataController>().initializeHealth(),
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNoDataMessage(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Icon(Icons.devices_other, size: 48),
//               const SizedBox(height: 16),
//               Text(
//                 'No Health Data Available',
//                 style: Theme.of(context).textTheme.titleLarge,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Connect a compatible device or enable health tracking to see your metrics.',
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () =>
//                     context.read<HealthDataController>().initializeHealth(),
//                 child: const Text('Connect Device'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//       child: Column(
//         children: [
//           Text(
//             "The addition of a wearable device can help generate important insights to your mental and physical health.",
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           OutlinedButton.icon(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const SelfReportPage(),
//               ),
//             ),
//             icon: const Icon(Icons.add_chart),
//             label: const Text('Add Self Report'),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvailabilityMessage(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Icon(Icons.info_outline),
//               const SizedBox(height: 8),
//               Text(
//                 'Some health metrics are not available on your device',
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'This could be due to device limitations or missing permissions.',
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withOpacity(0.7),
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindaigle/features/wearable_device/controller/Health_Data_Controller.dart';
import '../widgets/device_status_card.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/sync_button.dart';
import 'package:mindaigle/features/self-report/views/self_report_page.dart';
import '../models/health_metrics.dart';

class WearableDevicePage extends StatelessWidget {
  const WearableDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthDataController()..initializeHealth(),
      child: const WearableDeviceView(),
    );
  }
}

class WearableDeviceView extends StatelessWidget {
  const WearableDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HealthDataController>();
    final metrics = controller.healthMetrics;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wearable Device"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelfReportPage(),
                ),
              ),
              icon: const Icon(Icons.edit_note),
              tooltip: 'Self Report',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.manualSync,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              if (controller.isLoading)
                const _LoadingIndicator()
              else if (controller.errorMessage != null)
                _buildErrorMessage(context, controller.errorMessage!)
              else
                _buildHealthDataContent(context, controller, metrics),
              if (!controller.isLoading && controller.errorMessage == null)
                _buildFooter(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Health Tracking",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Track your physical health metrics to better understand your overall well-being.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelfReportPage(),
              ),
            ),
            icon: const Icon(Icons.add_chart),
            label: const Text('Add Self Report'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataContent(
    BuildContext context,
    HealthDataController controller,
    HealthMetrics? metrics,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DeviceStatusCard(
            status: controller.deviceStatus,
            batteryLevel: 100,
          ),
        ),
        SyncButton(
          onSync: controller.manualSync,
          isSyncing: controller.isLoading,
        ),
        if (metrics != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildMetricsGrid(context, metrics, controller),
          ),
        ],
      ],
    );
  }

  Widget _buildMetricsGrid(
    BuildContext context,
    HealthMetrics metrics,
    HealthDataController controller,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        HealthMetricCard(
          title: "Steps",
          value: "${metrics.steps.toStringAsFixed(0)} steps",
          icon: Icons.directions_walk,
          color: Colors.green.shade400,
          status: "normal",
        ),
        if (metrics.heartRate != null)
          HealthMetricCard(
            title: "Heart Rate",
            value: "${metrics.heartRate!.toStringAsFixed(0)} bpm",
            icon: Icons.favorite,
            color: Colors.red.shade400,
            status: "normal",
          ),
        if (metrics.temperature != null)
          HealthMetricCard(
            title: "Temperature",
            value: "${metrics.temperature!.toStringAsFixed(1)}°C",
            icon: Icons.thermostat_outlined,
            color: Colors.orange.shade400,
            status: "normal",
          ),
        if (metrics.sleepHours != null)
          HealthMetricCard(
            title: "Sleep",
            value: "${metrics.sleepHours!.toStringAsFixed(1)} hours",
            icon: Icons.bedtime,
            color: Colors.purple.shade300,
            status: "normal",
          ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, String message) {
    final controller = context.read<HealthDataController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.initializeHealth,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, HealthDataController controller) {
    if (controller.hasTemperature &&
        controller.hasHeartRate &&
        controller.hasSleep) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available Metrics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Some health metrics are not available. This could be due to:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildFeatureList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeatureItem(
          context,
          'Device Support',
          'Your device may not support all health metrics',
          Icons.devices,
        ),
        _buildFeatureItem(
          context,
          'Permissions',
          'Some health tracking permissions may not be granted',
          Icons.security,
        ),
        _buildFeatureItem(
          context,
          'Data Availability',
          'Some metrics may not be available from your health data provider',
          Icons.data_usage,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading health data...'),
          ],
        ),
      ),
    );
  }
}
