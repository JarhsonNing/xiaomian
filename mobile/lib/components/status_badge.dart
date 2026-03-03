import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label;

    switch (status) {
      case 'PENDING':
        badgeColor = Colors.orange;
        label = 'Saved Offline';
        break;
      case 'SYNCING':
        badgeColor = Colors.blue;
        label = 'Syncing...';
        break;
      case 'FAILED':
        badgeColor = Colors.red;
        label = 'Sync Failed';
        break;
      default:
        badgeColor = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
