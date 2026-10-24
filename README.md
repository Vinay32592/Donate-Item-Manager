# 🌿 Donation Item Manager (Flutter Application)

> **Theme:** Community Donation Management Mobile Application  
> **Target Platform:** Android & iOS (via Flutter / FlutLab)  
> **Architecture:** In-Memory State (`setState()`)  

---

## 1. Project Overview & Introduction

**Donation Item Manager** is a beginner-friendly, clean mobile application built using **Flutter and Dart**. The application assists individuals, student groups, and neighborhood organizers in cataloging reusable household goods—such as clothes, textbooks, toys, cookware, and groceries—so they can be donated to people in need rather than ending up in domestic landfills.

Through an intuitive, warm, and uncluttered interface, users can log items, view their collection, update item specifications, mark items as donated upon delivery, and filter items by category. Live dashboard statistics provide instant, real-time feedback on donation inventory.

---

## 2. Problem Statement & Motivation

Every year, tons of reusable, undamaged goods are discarded into domestic waste streams due to a lack of organized, local item tracking. Simultaneously, low-income families and students face hurdles acquiring basic essentials like warm clothing, study books, and kitchenware.

Without a straightforward personal inventory tool, donors often forget what items they have set aside, leading to clutter and eventual disposal. **Donation Item Manager** solves this problem by providing a pocket digital registry that encourages item reuse, resource circularity, and community mutual aid.

---

## 3. Project Objectives

1. **Promote Resource Sharing & Reuse:** Encourage people to extend the lifecycle of usable consumer items through proactive donation.
2. **Support Local Communities:** Facilitate the redistribution of essential commodities to families in need.
3. **Beginner-Friendly Flutter Architecture:** Demonstrate fundamental Flutter concepts (`StatefulWidget`, `setState()`, `ListView`, `TextFormField`, validation, and `Navigator`) without third-party package dependencies.
4. **FlutLab & Mobile Compatibility:** Ensure zero-configuration execution on FlutLab and native Android/iOS emulators.

---

## 4. Technology Stack

- **Framework:** Flutter (Material 3 Design)
- **Language:** Dart
- **Target Platforms:** Android, iOS, Web Preview
- **Architecture:** Local In-Memory State (`setState()`)
- **Dependencies:** Standard Flutter SDK only (`cupertino_icons` optional)
- **Third-Party Libraries:** **None** (No Firebase, No Supabase, No Provider, No Bloc)

---

## 5. Key Application Features

| Feature | Description |
| :--- | :--- |
| **Dynamic Dashboard** | Displays live metric cards: **Total Items**, **Available Items**, and **Donated Items**. Automatically recalculates when any item changes. |
| **Category Filtering** | Filter items in real time across **Clothes, Books, Toys, Household Items, Food, and Other**, plus an "All" view with live item counts. |
| **Item Validation Form** | Validates item name, category, quantity (positive whole numbers), condition, and description with friendly error prompts. |
| **Item Details View** | Displays complete specifications (quantity, condition, category, description, and status) with direct action shortcuts. |
| **Edit Item Details** | Pre-fills existing information, allowing users to modify specifications seamlessly. |
| **Mark as Donated** | Quick toggle button to transition items between **Available** and **Donated** states. |
| **Safe Deletion** | Prompts users with a confirmation `AlertDialog` before removing an item to prevent accidental data loss. |
| **Empty States** | Helpful visual empty states with a direct call-to-action button when no items match. |

---

## 6. Project Directory Structure

```text
donation_item_manager/
│
├── analysis_options.yaml       # Standard Flutter lint rules
├── pubspec.yaml                # Project metadata & standard dependencies
├── README.md                   # Complete documentation & viva guide
│
├── lib/
│   ├── main.dart               # App entry point & Material theme setup
│   │
│   ├── models/
│   │   └── donation_item.dart  # DonationItem data class & sample data
│   │
│   ├── screens/
│   │   ├── main_navigation_screen.dart  # Central state container & bottom tabs
│   │   ├── home_screen.dart             # Dashboard with live statistics
│   │   ├── donation_list_screen.dart    # Filterable list & empty states
│   │   ├── add_donation_screen.dart     # Validated entry form
│   │   ├── edit_donation_screen.dart    # Pre-filled edit form
│   │   └── item_details_screen.dart     # Comprehensive item details & actions
│   │
│   └── widgets/
│       ├── donation_item_card.dart      # Reusable item card with status badges
│       └── stat_card.dart               # Dashboard dynamic statistic card
│
├── android/                    # Native Android project configuration
├── ios/                        # Native iOS runner configuration
└── web/                        # Standard web runner for browser previews
```

---

## 7. Step-by-Step Setup & Running in FlutLab

FlutLab is an online Flutter IDE that runs inside any web browser without needing Flutter installed on your PC.

### Method 1: Creating a New Project & Pasting Files (Recommended for Beginners)
1. Open your browser and go to [https://flutlab.io](https://flutlab.io).
2. Log in or create a free student account.
3. Click **"+ New Project"** and select **"Flutter"** (Template: Minimal / Blank).
4. Name your project: `donation_item_manager`.
5. In the FlutLab file tree on the left:
   - Replace `pubspec.yaml` with the code in `pubspec.yaml`.
   - In `lib/`, create the folders `models`, `screens`, and `widgets`.
   - Copy and paste the corresponding `.dart` files into these folders.
6. Click the green **"Build & Run"** button (or press `Ctrl + R` / `Cmd + R`).
7. Your app will launch in the FlutLab web emulator!

### Method 2: Uploading as a ZIP file to FlutLab
1. Locate `donation_item_manager.zip` on your computer Desktop.
2. On [https://flutlab.io](https://flutlab.io), click **"Upload ZIP"** and select the ZIP file.
3. Once imported, select Web or Android target and click **"Run"**.

