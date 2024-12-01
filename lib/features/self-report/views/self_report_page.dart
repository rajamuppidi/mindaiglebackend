// // lib/features/self_report/views/self_report_page.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/self_report_controller.dart';
// import 'package:mindaigle/features/self-report/widgets/metric_slider_card.dart';
// import 'package:mindaigle/features/self-report/widgets/wellness_score_card.dart';

// class SelfReportPage extends StatelessWidget {
//   const SelfReportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => SelfReportController(),
//       child: const SelfReportView(),
//     );
//   }
// }

// class SelfReportView extends StatelessWidget {
//   const SelfReportView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final controller = context.watch<SelfReportController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Daily Health Check-in'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               WellnessScoreCard(score: controller.wellnessScore),
//               const SizedBox(height: 24),
//               MetricSliderCard(
//                 title: 'Hydration',
//                 subtitle: 'How many glasses of water today?',
//                 value: controller.metrics.hydration.toDouble(),
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 icon: Icons.water_drop,
//                 color: Colors.blue,
//                 labelFormat: (value) => '${value.toInt()}/5',
//                 onChanged: (value) => controller.updateHydration(value.toInt()),
//               ),
//               MetricSliderCard(
//                 title: 'Nutrition',
//                 subtitle: 'How well did you eat today?',
//                 value: controller.metrics.nutrition.toDouble(),
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 icon: Icons.restaurant,
//                 color: Colors.green,
//                 labelFormat: (value) => '${value.toInt()}/5',
//                 onChanged: (value) => controller.updateNutrition(value.toInt()),
//               ),
//               MetricSliderCard(
//                 title: 'Mood',
//                 subtitle: 'How are you feeling today?',
//                 value: controller.metrics.mood.toDouble(),
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 icon: Icons.mood,
//                 color: Colors.amber,
//                 labelFormat: (value) => '${value.toInt()}/5',
//                 onChanged: (value) => controller.updateMood(value.toInt()),
//               ),
//               MetricSliderCard(
//                 title: 'Stress',
//                 subtitle: 'What\'s your stress level?',
//                 value: controller.metrics.stress.toDouble(),
//                 min: 1,
//                 max: 5,
//                 divisions: 4,
//                 icon: Icons.psychology,
//                 color: Colors.purple,
//                 labelFormat: (value) => '${value.toInt()}/5',
//                 onChanged: (value) => controller.updateStress(value.toInt()),
//               ),
//               const SizedBox(height: 24),
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed:
//                       controller.isSaving ? null : controller.saveMetrics,
//                   icon: controller.isSaving
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Icon(Icons.check),
//                   label:
//                       Text(controller.isSaving ? 'Saving...' : 'Save Report'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/features/self_report/views/self_report_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/self_report_controller.dart';
import '../widgets/emoji_metric_slider_card.dart';
import '../widgets/metric_slider_card.dart';

class SelfReportPage extends StatelessWidget {
  const SelfReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelfReportController(),
      child: const SelfReportView(),
    );
  }
}

class SelfReportView extends StatelessWidget {
  const SelfReportView({super.key});

  static const moodEmojis = ['😢', '😕', '😐', '🙂', '😄'];
  static const stressEmojis = ['😫', '😩', '😕', '😌', '😊'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<SelfReportController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Health Check-in'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricSliderCard(
                title: 'Hydration',
                subtitle: 'How many glasses of water today?',
                value: controller.metrics.hydration.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                icon: Icons.water_drop,
                color: Colors.blue,
                labelFormat: (value) => '${value.toInt()}/5',
                onChanged: (value) => controller.updateHydration(value.toInt()),
              ),
              MetricSliderCard(
                title: 'Nutrition',
                subtitle: 'How well did you eat today?',
                value: controller.metrics.nutrition.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                icon: Icons.restaurant,
                color: Colors.green,
                labelFormat: (value) => '${value.toInt()}/5',
                onChanged: (value) => controller.updateNutrition(value.toInt()),
              ),
              EmojiMetricSliderCard(
                title: 'Mood',
                subtitle: 'How are you feeling today?',
                value: controller.metrics.mood.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                emojis: moodEmojis,
                color: Colors.amber,
                onChanged: (value) => controller.updateMood(value.toInt()),
              ),
              EmojiMetricSliderCard(
                title: 'Stress',
                subtitle: 'What\'s your stress level?',
                value: controller.metrics.stress.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                emojis: stressEmojis,
                color: Colors.purple,
                onChanged: (value) => controller.updateStress(value.toInt()),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed:
                      controller.isSaving ? null : controller.saveMetrics,
                  icon: controller.isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(
                      controller.isSaving ? 'Submitting...' : 'Submit Report'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
