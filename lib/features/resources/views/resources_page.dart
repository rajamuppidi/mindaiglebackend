import 'package:flutter/material.dart';
import 'package:mindaigle/core/theme/theme.dart';
import 'package:mindaigle/features/resources/food/views/food_page.dart';
import 'package:mindaigle/features/resources/transportation/views/transportation_page.dart';
import 'package:mindaigle/features/resources/Self-Help/views/self_help_page.dart'; // Update this import

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
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
              'Your resources have been organized into the following categories:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildResourceCategory(
                  context: context,
                  icon: Icons.favorite,
                  title: 'Self Help',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelfHelpPage()),
                    );
                  },
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.handshake,
                  title: 'Support',
                  onTap: () {},
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.fastfood,
                  title: 'Food',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FoodPage()),
                    );
                  },
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.commute,
                  title: 'Transportation',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TransportationPage()),
                    );
                  },
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.home,
                  title: 'Housing',
                  onTap: () {},
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.medical_services,
                  title: 'Medical Services',
                  onTap: () {},
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.group,
                  title: 'My Circle',
                  onTap: () {},
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.sos_sharp,
                  title: 'Crisis Service',
                  onTap: () {},
                ),
                _buildResourceCategory(
                  context: context,
                  icon: Icons.record_voice_over_sharp,
                  title: 'Aigle',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.network(
                'https://images.unsplash.com/photo-1579208570378-8c970854bc23?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxtZWRpY2FsJTIwc3VwcG9ydHxlbnwwfHx8fDE3MDcyNTEyMDN8MA&ixlib=rb-4.0.3&q=80&w=1080',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCategory({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
