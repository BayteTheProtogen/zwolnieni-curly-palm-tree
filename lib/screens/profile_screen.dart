import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';
import '../data/lesson_data.dart';
import '../models/lesson_models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Twój Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CyberMascot(expression: MascotExpression.happy, size: 120),
            const SizedBox(height: 24),
            Text('Cyber Bohater', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildStatCard(context, 'Punkty Doświadczenia', '${appProvider.xp} XP', Icons.stars, Colors.amber),
            _buildStatCard(context, 'Dni z rzędu', '${appProvider.streak}', Icons.local_fire_department, Colors.orange),
            const SizedBox(height: 32),
            _buildBadgeSection(context, appProvider),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Ustawienia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildFontSizeSlider(context, appProvider),
            ListTile(
              title: const Text('Wysoki kontrast'),
              trailing: Switch(
                value: appProvider.highContrast,
                onChanged: (val) => appProvider.setHighContrast(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }

  Widget _buildBadgeSection(BuildContext context, AppProvider provider) {
    final List<CyberBadge> allBadges = cybersecurityModules
        .where((m) => m.badge != null)
        .map((m) => m.badge!)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Twoje Odznaki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: allBadges.length,
          itemBuilder: (context, index) {
            final badge = allBadges[index];
            final bool isEarned = provider.earnedBadgeIds.contains(badge.id);
            return Opacity(
              opacity: isEarned ? 1.0 : 0.3,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isEarned ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: isEarned ? Colors.blue : Colors.grey),
                    ),
                    child: Text(badge.icon, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    badge.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Wielkość tekstu'),
              Text(
                provider.fontSizeMultiplier > 1.2 ? 'Duża' : 'Normalna',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Slider(
          value: provider.fontSizeMultiplier,
          min: 0.8,
          max: 1.8,
          divisions: 5,
          onChanged: (val) => provider.setFontSizeMultiplier(val),
        ),
      ],
    );
  }
}
