/// DonationItem Model
///
/// This simple Dart class represents a single item pledged for donation.
/// It uses basic Dart types (int, String, bool) without complex abstractions,
/// making it easy to explain during an academic viva.
class DonationItem {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final String condition;
  final String description;
  bool isDonated;

  DonationItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.condition,
    required this.description,
    this.isDonated = false,
  });

  /// Creates a copy of this item with modified properties.
  /// Useful when editing item details.
  DonationItem copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    String? condition,
    String? description,
    bool? isDonated,
  }) {
    return DonationItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      isDonated: isDonated ?? this.isDonated,
    );
  }

  /// Initial sample items to populate the application on first launch.
  /// These demonstrate diverse categories, quantities, and statuses.
  static List<DonationItem> getSampleItems() {
    return [
      DonationItem(
        id: 1,
        name: 'Winter Fleece Jackets',
        category: 'Clothes',
        quantity: 4,
        condition: 'Good',
        description: 'Warm, freshly washed winter jackets suitable for teenagers and young adults.',
        isDonated: false,
      ),
      DonationItem(
        id: 2,
        name: 'Science & Math Textbooks',
        category: 'Books',
        quantity: 6,
        condition: 'Good',
        description: 'High school reference books with clear diagrams and solved sample exercises.',
        isDonated: false,
      ),
      DonationItem(
        id: 3,
        name: 'Wooden Building Blocks',
        category: 'Toys',
        quantity: 2,
        condition: 'New',
        description: 'Safe, non-toxic educational geometric building block sets for kindergarten children.',
        isDonated: true,
      ),
      DonationItem(
        id: 4,
        name: 'Stainless Steel Cookware',
        category: 'Household Items',
        quantity: 3,
        condition: 'Usable',
        description: 'Sturdy cooking pots and pans in good working condition for family kitchens.',
        isDonated: false,
      ),
      DonationItem(
        id: 5,
        name: 'Packaged Grains & Pulses',
        category: 'Food',
        quantity: 8,
        condition: 'New',
        description: 'Sealed 1kg packets of rice and lentils with 9 months shelf life remaining.',
        isDonated: true,
      ),
    ];
  }
}
