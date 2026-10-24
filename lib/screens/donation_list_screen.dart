import 'package:flutter/material.dart';
import '../models/donation_item.dart';
import '../widgets/donation_item_card.dart';

/// DonationListScreen
///
/// Shows all listed donation items with category filtering,
/// live status badges, empty states, and full CRUD actions.
class DonationListScreen extends StatefulWidget {
  final List<DonationItem> items;
  final VoidCallback onNavigateToAdd;
  final Function(DonationItem) onTapItem;
  final Function(DonationItem) onEditItem;
  final Function(int) onToggleStatus;
  final Function(int) onDeleteItem;

  const DonationListScreen({
    super.key,
    required this.items,
    required this.onNavigateToAdd,
    required this.onTapItem,
    required this.onEditItem,
    required this.onToggleStatus,
    required this.onDeleteItem,
  });

  @override
  State<DonationListScreen> createState() => _DonationListScreenState();
}

class _DonationListScreenState extends State<DonationListScreen> {
  String _selectedCategory = 'All';

  final List<String> _filterCategories = [
    'All',
    'Clothes',
    'Books',
    'Toys',
    'Household Items',
    'Food',
    'Other',
  ];

  /// Confirmation dialog before deleting an item
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
            'Are you sure you want to remove "${item.name}" from your donation list? This action cannot be undone.',
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
                widget.onDeleteItem(item.id); // Perform delete
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
    // Apply category filtering
    final filteredItems = _selectedCategory == 'All'
        ? widget.items
        : widget.items.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text(
          'Donation Items',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Donation',
            onPressed: widget.onNavigateToAdd,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chip Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _filterCategories[index];
                  final isSelected = _selectedCategory == category;

                  // Count matching items for this chip
                  final count = category == 'All'
                      ? widget.items.length
                      : widget.items.where((i) => i.category == category).length;

                  return FilterChip(
                    label: Text(
                      '$category ($count)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF263238),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1B5E20),
                    backgroundColor: const Color(0xFFF1F4F1),
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF1B5E20) : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Items Count Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 'All'
                      ? 'All Listed Items (${filteredItems.length})'
                      : 'Category: $_selectedCategory (${filteredItems.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                if (_selectedCategory != 'All')
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                    child: const Text(
                      'Clear Filter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // List View or Empty State
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.category_rounded,
                              size: 48,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedCategory == 'All'
                                ? 'No donation items found'
                                : 'No items found in "$_selectedCategory"',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selectedCategory == 'All'
                                ? 'Tap "+ Add Item" to list your first donation item for community reuse.'
                                : 'Try selecting another category or add a new donation in this category.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: widget.onNavigateToAdd,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Donation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B5E20),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 20),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return DonationItemCard(
                        item: item,
                        onTap: () => widget.onTapItem(item),
                        onEdit: () => widget.onEditItem(item),
                        onToggleStatus: () => widget.onToggleStatus(item.id),
                        onDelete: () => _confirmDelete(context, item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
