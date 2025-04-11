// ignore_for_file: depend_on_referenced_packages, lines_longer_than_80_chars

import 'dart:async';

import 'package:ht_preferences_client/ht_preferences_client.dart';

/// {@template ht_preferences_repository}
/// Repository for managing user preferences.
///
/// This repository acts as an intermediary between the application's
/// business logic (BLoCs) and the data source client (`HtPreferencesClient`).
/// It handles potential client-level exceptions and enforces additional
/// business rules, such as limiting the size of the headline reading history.
/// {@endtemplate}
class HtPreferencesRepository {
  /// {@macro ht_preferences_repository}
  ///
  /// Requires an instance of [HtPreferencesClient] to interact with the
  /// underlying data source.
  ///
  /// The [maxHistorySize] parameter determines the maximum number of headlines
  /// to keep in the reading history. Defaults to 100.
  const HtPreferencesRepository({
    required HtPreferencesClient preferencesClient,
    this.maxHistorySize = 25, // Default history size reduced to 25
  }) : _preferencesClient = preferencesClient;

  final HtPreferencesClient _preferencesClient;

  /// The maximum number of headlines to store in the reading history.
  final int maxHistorySize;

  /// Gets the app settings.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<AppSettings> getAppSettings() async {
    try {
      return await _preferencesClient.getAppSettings();
    } on PreferenceNotFoundException {
      rethrow; // Propagate specific exceptions
    } on PreferenceUpdateException {
      rethrow; // Propagate specific exceptions
    } catch (e, stackTrace) {
      // Catch unexpected errors and wrap them
      throw PreferenceUpdateException(
        'Unexpected error getting app settings: $e\n$stackTrace',
      );
    }
  }

  /// Sets the app settings.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setAppSettings(AppSettings settings) async {
    try {
      await _preferencesClient.setAppSettings(settings);
    } on PreferenceUpdateException {
      rethrow; // Propagate specific exceptions
    } catch (e, stackTrace) {
      // Catch unexpected errors and wrap them
      throw PreferenceUpdateException(
        'Unexpected error setting app settings: $e\n$stackTrace',
      );
    }
  }

  /// Gets the article settings.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<ArticleSettings> getArticleSettings() async {
    try {
      return await _preferencesClient.getArticleSettings();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting article settings: $e\n$stackTrace',
      );
    }
  }

  /// Sets the article settings.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setArticleSettings(ArticleSettings settings) async {
    try {
      await _preferencesClient.setArticleSettings(settings);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting article settings: $e\n$stackTrace',
      );
    }
  }

  /// Gets the theme settings.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<ThemeSettings> getThemeSettings() async {
    try {
      return await _preferencesClient.getThemeSettings();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting theme settings: $e\n$stackTrace',
      );
    }
  }

  /// Sets the theme settings.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setThemeSettings(ThemeSettings settings) async {
    try {
      await _preferencesClient.setThemeSettings(settings);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting theme settings: $e\n$stackTrace',
      );
    }
  }

  /// Gets the complete list of bookmarked headlines.
  ///
  /// Throws [PreferenceNotFoundException] if the user's bookmarks
  /// cannot be found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<List<Headline>> getBookmarkedHeadlines() async {
    try {
      return await _preferencesClient.getBookmarkedHeadlines();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting bookmarked headlines: $e\n$stackTrace',
      );
    }
  }

  /// Adds a headline to the user's bookmarks.
  ///
  /// Does nothing if the headline is already bookmarked.
  ///
  /// [headline] The headline object to bookmark.
  ///
  /// Throws [PreferenceUpdateException] if adding the bookmark fails.
  Future<void> addBookmarkedHeadline(Headline headline) async {
    try {
      // Check if already bookmarked (optional, client might handle this)
      // final currentBookmarks = await getBookmarkedHeadlines();
      // if (currentBookmarks.any((h) => h.id == headline.id)) {
      //   return; // Already bookmarked
      // }
      await _preferencesClient.addBookmarkedHeadline(headline);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error adding bookmarked headline: $e\n$stackTrace',
      );
    }
  }

  /// Removes a headline from the user's bookmarks using its ID.
  ///
  /// [headlineId] The unique identifier of the headline to remove.
  /// Throws [PreferenceUpdateException] if removing the bookmark fails.
  Future<void> removeBookmarkedHeadline(String headlineId) async {
    try {
      await _preferencesClient.removeBookmarkedHeadline(headlineId);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error removing bookmarked headline: $e\n$stackTrace',
      );
    }
  }

  /// Gets the followed sources.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<List<Source>> getFollowedSources() async {
    try {
      return await _preferencesClient.getFollowedSources();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting followed sources: $e\n$stackTrace',
      );
    }
  }

  /// Sets the followed sources.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setFollowedSources(List<Source> sources) async {
    try {
      await _preferencesClient.setFollowedSources(sources);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting followed sources: $e\n$stackTrace',
      );
    }
  }

  /// Gets the followed categories.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<List<Category>> getFollowedCategories() async {
    try {
      return await _preferencesClient.getFollowedCategories();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting followed categories: $e\n$stackTrace',
      );
    }
  }

  /// Sets the followed categories.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setFollowedCategories(List<Category> categories) async {
    try {
      await _preferencesClient.setFollowedCategories(categories);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting followed categories: $e\n$stackTrace',
      );
    }
  }

  /// Gets the followed event countries.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<List<Country>> getFollowedEventCountries() async {
    try {
      return await _preferencesClient.getFollowedEventCountries();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting followed event countries: $e\n$stackTrace',
      );
    }
  }

  /// Sets the followed event countries.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setFollowedEventCountries(List<Country> countries) async {
    try {
      await _preferencesClient.setFollowedEventCountries(countries);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting followed event countries: $e\n$stackTrace',
      );
    }
  }

  /// Gets the complete headline reading history.
  ///
  /// Throws [PreferenceNotFoundException] if the user's reading
  /// history cannot be found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<List<Headline>> getHeadlineReadingHistory() async {
    try {
      return await _preferencesClient.getHeadlineReadingHistory();
    } on PreferenceNotFoundException {
      // If not found by client, return empty list as per repository logic
      return [];
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting headline reading history: $e\n$stackTrace',
      );
    }
  }

  /// Adds a headline to the user's reading history.
  ///
  /// Ensures the history does not exceed [maxHistorySize]. If the headline
  /// already exists, it's moved to the top (most recent).
  ///
  /// [headline] The headline object to add to the history.
  ///
  /// Throws [PreferenceUpdateException] if adding or removing from history fails.
  Future<void> addHeadlineToHistory(Headline headline) async {
    List<Headline> currentHistory;
    try {
      // Fetch current history, default to empty list if not found
      currentHistory = await _preferencesClient.getHeadlineReadingHistory();
    } on PreferenceNotFoundException {
      currentHistory = [];
    } on PreferenceUpdateException {
      rethrow; // Propagate fetch errors
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error fetching history before adding: $e\n$stackTrace',
      );
    }

    // Use a Set for efficient ID checking and removal, then convert back
    final historySet = currentHistory.toSet();
    // Remove existing entry if present to move it to the top later
    historySet.removeWhere((h) => h.id == headline.id);

    // Convert back to list and add the new headline at the beginning
    final updatedHistoryList = [headline, ...historySet];

    // Identify headlines to remove if limit is exceeded
    final headlinesToRemove = <Headline>[];
    if (updatedHistoryList.length > maxHistorySize) {
      headlinesToRemove.addAll(
        updatedHistoryList.sublist(maxHistorySize),
      );
    }

    try {
      // Add the new headline via the client
      await _preferencesClient.addHeadlineToHistory(headline);

      // Remove oldest headlines via the client if necessary
      for (final oldHeadline in headlinesToRemove) {
        // Ignore errors during removal of old items, as adding the new one
        // is the primary goal. Log potentially?
        try {
          await _preferencesClient.removeHeadlineToHistory(oldHeadline.id);
        } catch (_) {
          // Log removal error? For now, we suppress it.
          // print('Warning: Failed to remove old history item ${oldHeadline.id}');
        }
      }
    } on PreferenceUpdateException {
      rethrow; // Propagate client update errors
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error updating headline history: $e\n$stackTrace',
      );
    }
  }

  /// Removes a headline from the user's reading history using its ID.
  ///
  /// [headlineId] The unique identifier of the headline to remove from history.
  ///
  /// Throws [PreferenceUpdateException] if removing from history fails.
  Future<void> removeHeadlineToHistory(String headlineId) async {
    try {
      await _preferencesClient.removeHeadlineToHistory(headlineId);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error removing headline from history: $e\n$stackTrace',
      );
    }
  }

  /// Gets the feed settings.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<FeedSettings> getFeedSettings() async {
    try {
      return await _preferencesClient.getFeedSettings();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting feed settings: $e\n$stackTrace',
      );
    }
  }

  /// Sets the feed settings.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setFeedSettings(FeedSettings settings) async {
    try {
      await _preferencesClient.setFeedSettings(settings);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting feed settings: $e\n$stackTrace',
      );
    }
  }

  /// Gets the notification settings.
  ///
  /// Throws [PreferenceNotFoundException] if not found.
  /// Throws [PreferenceUpdateException] if fetching fails.
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      return await _preferencesClient.getNotificationSettings();
    } on PreferenceNotFoundException {
      rethrow;
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error getting notification settings: $e\n$stackTrace',
      );
    }
  }

  /// Sets the notification settings.
  ///
  /// Throws [PreferenceUpdateException] if update fails.
  Future<void> setNotificationSettings(NotificationSettings settings) async {
    try {
      await _preferencesClient.setNotificationSettings(settings);
    } on PreferenceUpdateException {
      rethrow;
    } catch (e, stackTrace) {
      throw PreferenceUpdateException(
        'Unexpected error setting notification settings: $e\n$stackTrace',
      );
    }
  }
}
