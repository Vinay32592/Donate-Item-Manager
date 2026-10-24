import 'package:flutter/material.dart';
import '../models/donation_item.dart';
import 'home_screen.dart';
import 'donation_list_screen.dart';
import 'add_donation_screen.dart';
import 'edit_donation_screen.dart';
import 'item_details_screen.dart';

/// MainNavigationScreen
///
/// Serves as the central state container and navigation hub for the application.
/// It maintains the list of donation items in memory (`_items`) and updates
/// all views synchronously whenever items are added, edited, toggled, or deleted.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Single source of truth: In-memory list initialized with realistic sample items
  late List<DonationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = DonationItem.getSampleItems();
  }

  // --- State Manipulation Methods ---

  /// Adds a new donation item to the list
  void _addItem(DonationItem newItem) {
    setState(() {
      _items.add(newItem);
    });
  }

  /// Updates an existing item's details
  void _updateItem(DonationItem updatedItem) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
      }
    });
  }

  /// Removes an item from the list
  void _deleteItem(int id) {
    setState(() {
      _items.removeWhere((i) => i.id == id);
    });
  }

  /// Toggles an item's status between Available and Donated
  void _toggleDonatedStatus(int id) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        _items[index].isDonated = !_items[index].isDonated;
      }
    });
  }

  /// Resets items to default sample data
  void _resetToSampleData() {
    setState(() {
      _items = DonationItem.getSampleItems();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sample items restored successfully.'),
        backgroundColor: const Color(0xFF1B5E20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Clears all items from the list with a confirmation dialog
  void _clearAllItems() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 26),
              const SizedBox(width: 10),
              const Text('Clear All Items?'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete all items? This will empty the donation list for demo testing.',
            style: TextStyle(fontSize: 14),
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
                Navigator.pop(dialogContext);
                setState(() {
                  _items.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All donation items have been cleared.'),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  // --- Screen Navigation Methods ---

  /// Navigates to the Add Donation Screen
  void _openAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDonationScreen(
          onAddItem: _addItem,
        ),
      ),
    );
  }

  /// Navigates to the Item Details Screen
  void _openDetailsScreen(DonationItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatefulBuilder(
          builder: (context, setDetailState) {
            // Find the most current version of this item
            final currentItem = _items.firstWhere(
              (i) => i.id == item.id,
              orElse: () => item,
            );
            return ItemDetailsScreen(
              item: currentItem,
              onEdit: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDonationScreen(
                      item: currentItem,
                      onUpdateItem: (updated) {
                        _updateItem(updated);
                        setDetailState(() {});
                      },
                    ),
                  ),
                );
              },
              onToggleStatus: () {
                _toggleDonatedStatus(currentItem.id);
                setDetailState(() {});
              },
              onDelete: () {
                _deleteItem(currentItem.id);
              },
            );
          },
        ),
      ),
    );
  }

  /// Navigates to the Edit Donation Screen
  void _openEditScreen(DonationItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDonationScreen(
          item: item,
          onUpdateItem: _updateItem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current active screen determined by bottom navigation index
    final List<Widget> screens = [
      HomeScreen(
        items: _items,
        onNavigateToList: () {
          setState(() {
            _currentIndex = 1; // switch to Items List tab
          });
        },
        onNavigateToAdd: _openAddScreen,
        onTapItem: _openDetailsScreen,
        onEditItem: _openEditScreen,
        onToggleStatus: _toggleDonatedStatus,
        onDeleteItem: _deleteItem,
      ),
      DonationListScreen(
        items: _items,
        onNavigateToAdd: _openAddScreen,
        onTapItem: _openDetailsScreen,
        onEditItem: _openEditScreen,
        onToggleStatus: _toggleDonatedStatus,
        onDeleteItem: _deleteItem,
        onResetSampleData: _resetToSampleData,
        onClearAllItems: _clearAllItems,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF1B5E20), // Deep green
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded),
              label: 'All Items',
            ),
          ],
        ),
      ),
      // Floating Action Button to quickly add items from Dashboard and List
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddScreen,
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
