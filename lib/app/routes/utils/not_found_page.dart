import 'package:flutter/material.dart';
import 'package:state_hub/app/routes/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const _NotFoundContent(),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        const HomeRoute().go(context);
                      },

                      label: const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundContent extends StatelessWidget {
  const _NotFoundContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 404 Icon with glassmorphism background
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle with gradient
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor.withValues(alpha: 0.1),
                      theme.primaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              // 404 Icon
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: theme.primaryColor,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // 404 Title
        Text(
          '404',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
            fontSize: 64,
            height: 1,
          ),
        ),

        const SizedBox(height: 16),

        // Page Not Found title
        Text(
          'Page Not Found',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Description
        Text(
          "The page you're looking for doesn't exist or has been moved. "
          "Let's get you back on track.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
