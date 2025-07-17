import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssetCard extends StatelessWidget {
  final String assetName;
  final String status;

  const AssetCard({
    super.key,
    required this.assetName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(
              0xFFa4123f,
            ).withOpacity(0.1), // AppTheme.primaryColor
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.inventory_2,
            color: Color(0xFFa4123f), // AppTheme.primaryColor
            size: 24,
          ),
        ),
        title: Text(
          assetName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Status : $status',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 20,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
