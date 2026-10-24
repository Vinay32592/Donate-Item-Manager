import 'package:flutter/material.dart';
import '../models/donation_item.dart';
import '../widgets/stat_card.dart';
import '../widgets/donation_item_card.dart';

/// HomeScreen (Dashboard)
///
/// The welcoming home dashboard presenting:
/// 1. App banner and community reuse motivation
/// 2. Three dynamic statistic cards (Total, Available, Donated)
/// 3. Prominent "Add Donation" button
/// 4. Recently added donation items preview
/// 5. Quick navigation link to view all items
class HomeScreen extends StatelessWidget {
  final List<DonationItem> items;
  final VoidCallback onNavigateToList;
  final VoidCallback onNavigateToAdd;
  final Function(DonationItem) onTapItem;
  final Function(DonationItem) onEditItem;
  final Function(int) onToggleStatus;
  final Function(int) onDeleteItem;

  const HomeScreen({
    super.key,
    required this.items,
    required this.onNavigateToList,
    required this.onNavigateToAdd,
    required this.onTapItem,
    required this.onEditItem,
    required this.onToggleStatus,
    required this.onDeleteItem,
  });

  /// Confirmation dialog before deleting an item from the dashboard
  void _confirmDelete(BuildContext context, DonationItem item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 26),
              const SizedBox(width: 10),
              const Text('Delete Item?'),
            ],
          ),
          content: Text(
            'Are you sure you want to remove "${item.name}"? This action cannot be undone.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                onDeleteItem(item.id); // Perform delete
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${item.name}" was removed.'),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate metrics directly from the live list
    final int totalCount = items.length;
    final int availableCount = items.where((item) => !item.isDonated).length;
    final int donatedCount = items.where((item) => item.isDonated).length;

    // Retrieve the most recent items (up to 3 items, newest first)
    final recentItems = items.reversed.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner & Community Callout
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1B5E20), // Deep green
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Donation Item Manager',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Give reusable goods a second life',
                                style: TextStyle(
                                  color: Color(0xFFE8F5E9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volunteer_activism_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Community Sharing Badge & Micro-info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.handshake_outlined,
                            color: Color(0xFFFFF8E7),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Easily track, manage, and share reusable goods with your community.',
                              style: TextStyle(
                                color: Color(0xFFFFF8E7),
                                fontSize: 12,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Overview Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Donation Overview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    Text(
                      'Live Metrics',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Three Dynamic Statistic Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    StatCard(
                      title: 'Total Items',
                      count: totalCount,
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF1B5E20),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    StatCard(
                      title: 'Available',
                      count: availableCount,
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF2E7D32),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    StatCard(
                      title: 'Donated',
                      count: donatedCount,
                      icon: Icons.task_alt_rounded,
                      color: const Color(0xFFD35400), // Muted Orange accent
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Prominent "Add Donation" Banner Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E7), // Soft cream
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD35400).withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD35400).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_box_rounded,
                          color: Color(0xFFD35400),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Have items to share?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Clothes, books, toys, or home essentials',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onNavigateToAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '+ Add Item',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recent Items Header & "View All" Link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recently Listed Items',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    TextButton(
                      onPressed: onNavigateToList,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1B5E20),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.arrow_forward_ios_rounded, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // List of Recent Items or Empty State
              if (items.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 44,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No donation items listed yet',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263238),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap "+ Add Item" above to list your first donation.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...recentItems.map(
                  (item) => DonationItemCard(
                    item: item,
                    onTap: () => onTapItem(item),
                    onEdit: () => onEditItem(item),
                    onToggleStatus: () => onToggleStatus(item.id),
                    onDelete: () => _confirmDelete(context, item),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
