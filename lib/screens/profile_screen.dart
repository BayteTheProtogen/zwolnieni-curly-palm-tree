import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    const Color neonCyan = Color(0xFF00FFE0);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: const Text('Mój Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CyberMascot(expression: MascotExpression.neutral, size: 120),
            const SizedBox(height: 24),
            Text(
              'Cyber-Uczeń',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: neonCyan),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildStatCard('XP', '${provider.xp}', Icons.stars, Colors.amber)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Dni', '${provider.streak}', Icons.local_fire_department, Colors.orange)),
              ],
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Moje Odznaki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            provider.earnedBadgeIds.isEmpty
                ? _buildEmptyBadges()
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: provider.earnedBadgeIds.length,
                    itemBuilder: (context, index) {
                      final badgeId = provider.earnedBadgeIds.elementAt(index);
                      return _buildBadgeIcon(badgeId);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEmptyBadges() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('Ukończ moduły, aby zdobyć odznaki!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(String badgeId) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF00FFE0).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF00FFE0), width: 2),
            boxShadow: [
              BoxShadow(color: const Color(0xFF00FFE0).withValues(alpha: 0.2), blurRadius: 10),
            ],
          ),
          child: const Icon(Icons.verified, color: Color(0xFF00FFE0), size: 32),
        ),
        const SizedBox(height: 4),
        Text(badgeId, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161B22),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const SettingsPanel(),
    );
  }
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    const Color neonCyan = Color(0xFF00FFE0);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ustawienia Dostępności', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text('Wielkość tekstu', style: TextStyle(color: Colors.grey)),
          Slider(
            value: provider.fontSizeMultiplier,
            min: 1.0,
            max: 2.0,
            activeColor: neonCyan,
            onChanged: (val) => provider.setFontSizeMultiplier(val),
          ),
          SwitchListTile(
            title: const Text('Wysoki kontrast'),
            value: provider.highContrast,
            activeColor: neonCyan,
            onChanged: (val) => provider.setHighContrast(val),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ZAMKNIJ'),
            ),
          ),
        ],
      ),
    );
  }
}
