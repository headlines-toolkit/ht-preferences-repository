# ht_preferences_repository

![coverage: percentage](https://img.shields.io/badge/coverage-92-green)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis) 
[![License: PolyForm Free Trial](https://img.shields.io/badge/License-PolyForm%20Free%20Trial-blue)](https://polyformproject.org/licenses/free-trial/1.0.0)

> **Note:** This package is being archived. Please use the successor package [`ht-data-repository`](https://github.com/headlines-toolkit/ht-data-repository) instead.

Repository for managing user preferences. This repository acts as an intermediary between the application's business logic (BLoCs) and the data source client (`HtPreferencesClient`). It handles potential client-level exceptions and enforces additional business rules, such as limiting the size of the headline reading history.

## Overview

This package provides a `HtPreferencesRepository` class designed to abstract the storage and retrieval of user preferences within a Flutter application. It sits on top of a `HtPreferencesClient` implementation (which handles the actual data persistence, e.g., using Firestore, local storage, etc.) and provides a clean, consistent API for managing various user settings and data.

## Features

*   **Settings Management:** Get and set application, article, theme, feed, and notification settings.
*   **Bookmark Management:** Add, remove, and retrieve bookmarked headlines.
*   **Followed Items:** Manage lists of followed sources, categories, and event countries.
*   **Reading History:** Track headline reading history, automatically managing its size (defaults to 25 items).
*   **Error Handling:** Propagates specific exceptions (`PreferenceNotFoundException`, `PreferenceUpdateException`) from the client and wraps unexpected errors.
*   **Client Agnostic:** Works with any implementation of the `HtPreferencesClient` interface.

## Getting Started

Add the necessary packages to your `pubspec.yaml` file under dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # This repository package
  ht_preferences_repository:
    git:
      url: https://github.com/headlines-toolkit/ht-preferences-repository.git
      # Optionally specify a ref (branch, tag, commit hash):
      # ref: main

  # The client interface (required by the repository)
  ht_preferences_client:
    git:
      url: https://github.com/headlines-toolkit/ht-preferences-client.git
      # ref: main

  # A client implementation (e.g., Firestore)
  ht_preferences_firestore:
    git:
      url: https://github.com/headlines-toolkit/ht-preferences-firestore.git
      # ref: main

  # Other dependencies your client might need (e.g., cloud_firestore)
  cloud_firestore: ^4.0.0 # Example version
```

Then run `flutter pub get`.

## Usage

Import the necessary packages and instantiate the repository with your chosen `HtPreferencesClient` implementation (e.g., `HtPreferencesFirestore`). You'll typically do this where you provide dependencies to your application (like in `main.dart` or using a dependency injection framework).

```dart
import 'package:flutter/material.dart'; // For ThemeMode example
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore dependency
import 'package:ht_preferences_client/ht_preferences_client.dart';
import 'package:ht_preferences_repository/ht_preferences_repository.dart';
import 'package:ht_preferences_firestore/ht_preferences_firestore.dart'; // Import the client implementation

// Assume firestoreInstance and userId are available in your app context
// FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
// String userId = 'some_user_id';

void main() async {
  // --- Dependency Setup (Example) ---
  // In a real app, initialize Firebase, get user ID, etc.
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(...);
  final firestoreInstance = FirebaseFirestore.instance; // Replace with your actual instance
  const userId = 'test_user_123'; // Replace with actual user ID

  // Instantiate the Firestore client
  final preferencesClient = HtPreferencesFirestore(
    firestore: firestoreInstance,
    userId: userId,
  );

  // Create the repository instance, injecting the client
  final preferencesRepository = HtPreferencesRepository(
    preferencesClient: preferencesClient,
    maxHistorySize: 50, // Optionally override default history size (25)
  );
  // --- End Dependency Setup ---


  // --- Using the Repository ---
  try {
    // --- Settings ---
    // Get current app settings
    AppSettings currentAppSettings = await preferencesRepository.getAppSettings();
    print('Current App Font Size: ${currentAppSettings.appFontSize}');
    print('Current App Font Type: ${currentAppSettings.appFontType}');

    // Update app settings
    final newAppSettings = AppSettings(
      appFontSize: FontSize.large,
      appFontType: AppFontType.lato,
    );
    await preferencesRepository.setAppSettings(newAppSettings);
    print('App settings updated.');

    // Get theme settings
    ThemeSettings currentThemeSettings = await preferencesRepository.getThemeSettings();
    print('Current Theme Mode: ${currentThemeSettings.themeMode}');

    // Update theme settings
    final newThemeSettings = ThemeSettings(
      themeMode: AppThemeMode.dark, // Use enum from ht_preferences_client
      themeName: AppThemeName.blue, // Use enum from ht_preferences_client
    );
    await preferencesRepository.setThemeSettings(newThemeSettings);
    print('Theme settings updated.');

    // --- Bookmarks ---
    final headline1 = Headline(id: 'h1', title: 'Example Headline 1', description: 'Desc 1');
    final headline2 = Headline(id: 'h2', title: 'Example Headline 2', url: 'http://example.com');

    await preferencesRepository.addBookmarkedHeadline(headline1);
    print('Headline 1 bookmarked.');
    await preferencesRepository.addBookmarkedHeadline(headline2);
    print('Headline 2 bookmarked.');

    List<Headline> bookmarks = await preferencesRepository.getBookmarkedHeadlines();
    print('Current Bookmarks (${bookmarks.length}): ${bookmarks.map((h) => h.title).toList()}');

    await preferencesRepository.removeBookmarkedHeadline('h1');
    print('Headline 1 removed from bookmarks.');
    bookmarks = await preferencesRepository.getBookmarkedHeadlines();
    print('Updated Bookmarks (${bookmarks.length}): ${bookmarks.map((h) => h.title).toList()}');

    // --- Followed Items ---
    final categoryTech = Category(id: 'cat-tech', name: 'Technology');
    final categorySports = Category(id: 'cat-sports', name: 'Sports');
    await preferencesRepository.setFollowedCategories([categoryTech, categorySports]);
    print('Followed categories set.');

    List<Category> followedCategories = await preferencesRepository.getFollowedCategories();
    print('Followed Categories: ${followedCategories.map((c) => c.name).toList()}');

    // --- History ---
    final headline3 = Headline(id: 'h3', title: 'History Headline 3');
    await preferencesRepository.addHeadlineToHistory(headline1); // Add h1 back for history
    await preferencesRepository.addHeadlineToHistory(headline2);
    await preferencesRepository.addHeadlineToHistory(headline3);
    print('Headlines added to history.');

    List<Headline> history = await preferencesRepository.getHeadlineReadingHistory();
    print('Current History (${history.length} items): ${history.map((h) => h.title).toList()}');

    // Adding more items might prune the history based on maxHistorySize
    for (int i = 4; i < 60; i++) {
       await preferencesRepository.addHeadlineToHistory(Headline(id: 'h$i', title: 'History Headline $i'));
    }
    history = await preferencesRepository.getHeadlineReadingHistory();
    print('History after adding more (${history.length} items - potentially pruned): ${history.map((h) => h.title).toList()}');

    await preferencesRepository.removeHeadlineToHistory('h2');
    print('Headline 2 removed from history.');
    history = await preferencesRepository.getHeadlineReadingHistory();
    print('Updated History (${history.length} items): ${history.map((h) => h.title).toList()}');


  } on PreferenceNotFoundException catch (e) {
    // Handle cases where settings/data haven't been set yet
    print('Error: Preference not found - ${e.message}');
  } on PreferenceUpdateException catch (e) {
    // Handle errors during data fetching/saving
    print('Error: Failed to update preference - ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
```

## Error Handling

The repository methods may throw the following exceptions originating from the `ht_preferences_client`:

*   `PreferenceNotFoundException`: Thrown when a requested preference or data item (like settings or history) cannot be found.
*   `PreferenceUpdateException`: Thrown when an operation to fetch or update a preference fails (e.g., network error, database error).

It's recommended to wrap calls to the repository methods in `try-catch` blocks to handle these potential errors gracefully in your application's business logic layer (e.g., BLoCs).

## Dependencies

*   **ht_preferences_client:** This package relies heavily on the `ht_preferences_client` interface package, which defines the contract for interacting with the underlying preference data source. You will need to provide an implementation of `HtPreferencesClient` when creating the `HtPreferencesRepository`.

## License

This package is licensed under the [PolyForm Free Trial License 1.0.0](LICENSE). See the [LICENSE](LICENSE) file for details.
