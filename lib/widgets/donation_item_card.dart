import 'package:flutter/material.dart';
import '../models/donation_item.dart';

/// DonationItemCard
///
/// A clean, accessible card widget displaying a summary of an item.
/// It shows the item name, category badge, quantity, condition, and status,
/// with direct action buttons for viewing details, editing, toggling donation status,
/// and deleting.
class DonationItemCard extends StatelessWidget {
  final DonationItem item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const DonationItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  /// Helper to return a fitting Material icon for each donation category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Clothes':
        return Icons.checkroom_rounded;
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Toys':
        return Icons.smart_toy_rounded;
      case 'Household Items':
        return Icons.chair_rounded;
      case 'Food':
        return Icons.kitchen_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  /// Color-coding for each category to enhance visual aesthetics
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Clothes':
        return const Color(0xFF5E35B1); // Indigo
      case 'Books':
        return const Color(0xFF1E88E5); // Royal Blue
      case 'Toys':
        return const Color(0xFFE65100); // Warm Orange
      case 'Household Items':
        return const Color(0xFF00897B); // Teal
      case 'Food':
        return const Color(0xFF2E7D32); // Forest Green
      default:
        return const Color(0xFF546E7A); // Slate Grey
    }
  }

  /// Color-coding for condition badges
  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'New':
        return const Color(0xFF2E7D32); // Green
      case 'Good':
        return const Color(0xFF1565C0); // Blue
      case 'Usable':
        return const Color(0xFFD35400); // Amber
      default:
        return const Color(0xFF546E7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDonated = item.isDonated;
    final categoryColor = _getCategoryColor(item.category);
    final conditionColor = _getConditionColor(item.condition);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDonated ? Colors.grey.shade300 : categoryColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      color: isDonated ? const Color(0xFFFAFAFA) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Category Icon + Title + Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDonated
                          ? Colors.grey.shade200
                          : categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getCategoryIcon(item.category),
                      color: isDonated ? Colors.grey.shade600 : categoryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDonated ? Colors.grey.shade700 : const Color(0xFF263238),
                            decoration: isDonated ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDonated ? Colors.grey.shade600 : categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDonated
                          ? const Color(0xFFECEFF1)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDonated
                            ? Colors.blueGrey.shade200
                            : const Color(0xFFA5D6A7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDonated ? Icons.done_all_rounded : Icons.fiber_manual_record_rounded,
                          size: 13,
                          color: isDonated
                              ? Colors.blueGrey.shade700
                              : const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDonated ? 'Donated' : 'Available',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDonated
                                ? Colors.blueGrey.shade800
                                : const Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Description preview (if available)
              if (item.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Tags row: Quantity & Condition
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.numbers_rounded, size: 13, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 3),
                        Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: conditionColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: conditionColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_outlined, size: 13, color: conditionColor),
                        const SizedBox(width: 3),
                        Text(
                          item.condition,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: conditionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 18),

              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // View Details Link
                  TextButton.icon(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1B5E20),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text(
                      'Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Action Buttons: Toggle, Edit, Delete
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Toggle Donated Status
                        Tooltip(
                          message: isDonated ? 'Mark as Available' : 'Mark as Donated',
                          child: OutlinedButton(
                            onPressed: onToggleStatus,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDonated ? Colors.grey.shade700 : const Color(0xFF1B5E20),
                              side: BorderSide(
                                color: isDonated ? Colors.grey.shade400 : const Color(0xFF2E7D32),
                                width: 1,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isDonated ? 'Reopen' : 'Mark Donated',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          color: Colors.blueGrey.shade700,
                          tooltip: 'Edit Item',
                          visualDensity: VisualDensity.compact,
                          onPressed: onEdit,
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          color: Colors.red.shade600,
                          tooltip: 'Delete Item',
                          visualDensity: VisualDensity.compact,
                          onPressed: onDelete,
                        ),
                      ],
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
