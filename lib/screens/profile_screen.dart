import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tolak_tax/widgets/achievement_tile.dart';
import 'package:tolak_tax/widgets/settings_item.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = Provider.of<AuthService>(context).currentUser;
   
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: true,
              expandedHeight: 240,
              backgroundColor: colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.only(top: 60),
                  color: colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.displayName ?? 'No Name',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(user?.email ?? 'Email',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          )),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              foregroundColor: colorScheme.onPrimary,
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // achievement card here
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Achievements',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AchievementTile(
                                icon: Icons.savings,
                                label: 'RM 123.12',
                                subtitle: 'Total Savings',
                                width: 80,
                              ),
                              AchievementTile(
                                icon: Icons.local_fire_department,
                                label: '12 Days',
                                subtitle: 'Streak',
                                width: 80,
                              ),
                              AchievementTile(
                                icon: Icons.emoji_events,
                                label: 'Gold',
                                subtitle: 'Rank',
                                width: 80,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Settings', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SettingsItem(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.account_balance_wallet,
                      title: 'Budget Settings',
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.color_lens,
                      title: 'Theme',
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    Divider(color: Colors.grey.shade300),
                    SettingsItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () async {
                        final auth = Provider.of<AuthService>(context, listen: false);
                        await auth.signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
