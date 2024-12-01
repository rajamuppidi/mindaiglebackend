import 'package:flutter/material.dart';

class SelfHelpPage extends StatelessWidget {
  const SelfHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Help'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Here, you will find a variety of resources tailored to help you manage your mental health and wellness.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildResourceItem(
                  context: context,
                  icon: Icons.fact_check,
                  title: 'Anxiety Management',
                  onTap: () {
                    // Navigate to Anxiety Management page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.restaurant_menu,
                  title: 'Nutrition and Healthy Eating',
                  onTap: () {
                    // Navigate to Nutrition and Healthy Eating page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.nightlight_round,
                  title: 'Sleep Health',
                  onTap: () {
                    // Navigate to Sleep Health page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.fitness_center,
                  title: 'Physical Activity and Exercise',
                  onTap: () {
                    // Navigate to Physical Activity and Exercise page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.spa,
                  title: 'Mindfulness and Relaxation',
                  onTap: () {
                    // Navigate to Mindfulness and Relaxation page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.psychology,
                  title: 'Building Self-Esteem',
                  onTap: () {
                    // Navigate to Building Self-Esteem page
                  },
                ),
                _buildResourceItem(
                  context: context,
                  icon: Icons.more_horiz,
                  title: 'Additional Resources',
                  onTap: () {
                    // Navigate to Additional Resources page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColor),
        title: Text(title, style: theme.textTheme.bodyLarge),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
