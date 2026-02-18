import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';

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
            _buildStatCard(context, 'Ukończone lekcje', '${appProvider.completedLessons.length}', Icons.check_circle, Colors.green),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              title: const Text('Tryb Seniora'),
              trailing: Switch(
                value: appProvider.isSeniorMode,
                onChanged: (val) => appProvider.setSeniorMode(val),
              ),
            ),
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
}
