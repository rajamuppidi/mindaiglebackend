import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindaigle/features/dashboard/controllers/dashboard_controller.dart';
import 'package:mindaigle/features/dashboard/widgets/wellness_score_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/symptoms_log_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/activity_log_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/personalized_tips_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/resources_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/goals_progress_widget.dart';
import 'package:mindaigle/features/dashboard/widgets/personal_growth_widget.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const WellnessScoreWidget(),
              const SymptomsLogWidget(),
              const ActivityLogWidget(),
              PersonalizedTipsWidget(),
              const ResourcesWidget(),
              const Row(
                children: [
                  Flexible(child: GoalsProgressWidget()),
                  Flexible(child: PersonalGrowthWidget()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line
        children: [
          Row(
            children: [
              Obx(() => CircleAvatar(
                    radius: 30,
                    backgroundImage: controller.userPhotoUrl.isNotEmpty
                        ? NetworkImage(controller.userPhotoUrl.value)
                        : const AssetImage(
                                'assets/images/default_profile_picture.png')
                            as ImageProvider,
                  )),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Obx(() => Text(
                        controller.userName.value,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Get.toNamed('/profile'); // Navigate to the profile page
            },
          ),
        ],
      ),
    );
  }
}
