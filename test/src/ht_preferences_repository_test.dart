// ignore_for_file: prefer_const_constructors

import 'package:ht_preferences_client/ht_preferences_client.dart';
import 'package:ht_preferences_repository/ht_preferences_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Create a mock class for HtPreferencesClient
class MockHtPreferencesClient extends Mock implements HtPreferencesClient {}

// Create a fake class for Headline to use as a fallback
class FakeHeadline extends Fake implements Headline {}

// Create a fake class for Source to use as a fallback
class FakeSource extends Fake implements Source {}

// Create a fake class for Category to use as a fallback
class FakeCategory extends Fake implements Category {}

// Create a fake class for Country to use as a fallback
class FakeCountry extends Fake implements Country {}


void main() {
  // Register fallback values before any tests run
  setUpAll(() {
    registerFallbackValue(FakeHeadline());
    registerFallbackValue(FakeSource());
    registerFallbackValue(FakeCategory());
    registerFallbackValue(FakeCountry());
    registerFallbackValue(AppSettings(appFontSize: FontSize.medium, appFontType: AppFontType.roboto));
    registerFallbackValue(ArticleSettings(articleFontSize: FontSize.medium));
    registerFallbackValue(ThemeSettings(themeMode: AppThemeMode.dark, themeName: AppThemeName.blue));
    registerFallbackValue(FeedSettings(feedListTileType: FeedListTileType.imageStart));
    registerFallbackValue(NotificationSettings(enabled: false));
  });

  group('HtPreferencesRepository', () {
    late HtPreferencesClient mockPreferencesClient;
    late HtPreferencesRepository repository;
    // Default repository with standard history size
    late HtPreferencesRepository defaultRepository;

    setUp(() {
      // Initialize the mock client before each test
      mockPreferencesClient = MockHtPreferencesClient();
      // Instantiate the repository with the mock client and default size
      defaultRepository = HtPreferencesRepository(
        preferencesClient: mockPreferencesClient,
      );
      // Alias for clarity in most tests
      repository = defaultRepository;
    });

    test('can be instantiated', () {
      // Check if the repository instance created in setUp is not null
      expect(repository, isNotNull);
      // Verify the default history size
      expect(repository.maxHistorySize, equals(25));
    });

    // --- AppSettings ---

    group('AppSettings', () {
      final tAppSettings = AppSettings(
        appFontSize: FontSize.medium,
        appFontType: AppFontType.roboto,
      );
      final tException = Exception('Unexpected error');

      test('getAppSettings returns settings on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getAppSettings())
            .thenAnswer((_) async => tAppSettings);
        // Act
        final result = await repository.getAppSettings();
        // Assert
        expect(result, tAppSettings);
        verify(() => mockPreferencesClient.getAppSettings()).called(1);
      });

      test('getAppSettings throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getAppSettings())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getAppSettings(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getAppSettings()).called(1);
      });

      test('getAppSettings throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getAppSettings())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getAppSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getAppSettings()).called(1);
      });


      test('getAppSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getAppSettings())
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.getAppSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getAppSettings()).called(1);
      });

      test('setAppSettings completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setAppSettings(tAppSettings),
          completes,
        );
        verify(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .called(1);
      });

      test('setAppSettings throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setAppSettings(tAppSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .called(1);
      });

      test('setAppSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.setAppSettings(tAppSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setAppSettings(tAppSettings))
            .called(1);
      });
    });

    // --- ArticleSettings ---
    group('ArticleSettings', () {
      final tArticleSettings = ArticleSettings(articleFontSize: FontSize.large);
      final tException = Exception('Unexpected error');

      test('getArticleSettings returns settings on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getArticleSettings())
            .thenAnswer((_) async => tArticleSettings);
        // Act
        final result = await repository.getArticleSettings();
        // Assert
        expect(result, tArticleSettings);
        verify(() => mockPreferencesClient.getArticleSettings()).called(1);
      });

      test(
          'getArticleSettings throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getArticleSettings())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getArticleSettings(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getArticleSettings()).called(1);
      });

       test('getArticleSettings throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getArticleSettings())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getArticleSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getArticleSettings()).called(1);
      });

      test(
          'getArticleSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getArticleSettings())
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.getArticleSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getArticleSettings()).called(1);
      });

      test('setArticleSettings completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setArticleSettings(tArticleSettings),
          completes,
        );
        verify(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .called(1);
      });

      test(
          'setArticleSettings throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setArticleSettings(tArticleSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .called(1);
      });

       test(
          'setArticleSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.setArticleSettings(tArticleSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setArticleSettings(tArticleSettings))
            .called(1);
      });
    });

    // --- ThemeSettings ---
    group('ThemeSettings', () {
      final tThemeSettings = ThemeSettings(
        themeMode: AppThemeMode.dark,
        themeName: AppThemeName.blue,
      );
      final tException = Exception('Unexpected error');


      test('getThemeSettings returns settings on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getThemeSettings())
            .thenAnswer((_) async => tThemeSettings);
        // Act
        final result = await repository.getThemeSettings();
        // Assert
        expect(result, tThemeSettings);
        verify(() => mockPreferencesClient.getThemeSettings()).called(1);
      });

      test('getThemeSettings throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getThemeSettings())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getThemeSettings(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getThemeSettings()).called(1);
      });

       test('getThemeSettings throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getThemeSettings())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getThemeSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getThemeSettings()).called(1);
      });

      test(
          'getThemeSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getThemeSettings())
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.getThemeSettings(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getThemeSettings()).called(1);
      });

      test('setThemeSettings completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setThemeSettings(tThemeSettings),
          completes,
        );
        verify(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .called(1);
      });

      test('setThemeSettings throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setThemeSettings(tThemeSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .called(1);
      });

       test('setThemeSettings throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.setThemeSettings(tThemeSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setThemeSettings(tThemeSettings))
            .called(1);
      });
    });

    // --- BookmarkedHeadlines ---
    group('BookmarkedHeadlines', () {
      final tHeadline1 = Headline(id: '1', title: 'Bookmark 1');
      final tHeadline2 = Headline(id: '2', title: 'Bookmark 2');
      final tBookmarks = [tHeadline1, tHeadline2];
      final tException = Exception('Unexpected error');


      test('getBookmarkedHeadlines returns list on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getBookmarkedHeadlines())
            .thenAnswer((_) async => tBookmarks);
        // Act
        final result = await repository.getBookmarkedHeadlines();
        // Assert
        expect(result, tBookmarks);
        verify(() => mockPreferencesClient.getBookmarkedHeadlines()).called(1);
      });

      test(
          'getBookmarkedHeadlines throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getBookmarkedHeadlines())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getBookmarkedHeadlines(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getBookmarkedHeadlines()).called(1);
      });

       test('getBookmarkedHeadlines throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getBookmarkedHeadlines())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getBookmarkedHeadlines(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getBookmarkedHeadlines()).called(1);
      });

      test(
          'getBookmarkedHeadlines throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getBookmarkedHeadlines())
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.getBookmarkedHeadlines(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getBookmarkedHeadlines()).called(1);
      });

      test('addBookmarkedHeadline completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.addBookmarkedHeadline(tHeadline1),
          completes,
        );
        verify(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .called(1);
      });

      test(
          'addBookmarkedHeadline throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.addBookmarkedHeadline(tHeadline1),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .called(1);
      });

      test(
          'addBookmarkedHeadline throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.addBookmarkedHeadline(tHeadline1),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.addBookmarkedHeadline(tHeadline1))
            .called(1);
      });

      test('removeBookmarkedHeadline completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.removeBookmarkedHeadline('1'),
          completes,
        );
        verify(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .called(1);
      });

      test(
          'removeBookmarkedHeadline throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.removeBookmarkedHeadline('1'),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .called(1);
      });

      test(
          'removeBookmarkedHeadline throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.removeBookmarkedHeadline('1'),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.removeBookmarkedHeadline('1'))
            .called(1);
      });
    });

    // --- FollowedSources ---
    group('FollowedSources', () {
      final tSource1 = Source(id: 's1', name: 'Source 1');
      final tSources = [tSource1];
      final tException = Exception('Unexpected error');


      test('getFollowedSources returns list on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedSources())
            .thenAnswer((_) async => tSources);
        // Act
        final result = await repository.getFollowedSources();
        // Assert
        expect(result, tSources);
        verify(() => mockPreferencesClient.getFollowedSources()).called(1);
      });

      test(
          'getFollowedSources throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedSources())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getFollowedSources(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getFollowedSources()).called(1);
      });

       test('getFollowedSources throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedSources())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getFollowedSources(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getFollowedSources()).called(1);
      });

       test('getFollowedSources throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedSources())
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.getFollowedSources(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getFollowedSources()).called(1);
      });

      test('setFollowedSources completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.setFollowedSources(tSources))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setFollowedSources(tSources),
          completes,
        );
        verify(() => mockPreferencesClient.setFollowedSources(tSources))
            .called(1);
      });

      test(
          'setFollowedSources throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setFollowedSources(tSources))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setFollowedSources(tSources),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setFollowedSources(tSources))
            .called(1);
      });

       test(
          'setFollowedSources throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setFollowedSources(tSources))
            .thenThrow(tException);
        // Act & Assert
        await expectLater(
          repository.setFollowedSources(tSources),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setFollowedSources(tSources))
            .called(1);
      });
    });

    // --- FollowedCategories ---
    group('FollowedCategories', () {
      final tCategory1 = Category(id: 'c1', name: 'Category 1');
      final tCategories = [tCategory1];
      final tException = Exception('Unexpected error');


      test('getFollowedCategories returns list on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedCategories())
            .thenAnswer((_) async => tCategories);
        // Act
        final result = await repository.getFollowedCategories();
        // Assert
        expect(result, tCategories);
        verify(() => mockPreferencesClient.getFollowedCategories()).called(1);
      });

      test(
          'getFollowedCategories throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedCategories())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getFollowedCategories(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getFollowedCategories()).called(1);
      });

       test('getFollowedCategories throws PreferenceUpdateException on client update error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedCategories())
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.getFollowedCategories(),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.getFollowedCategories()).called(1);
      });

       test('getFollowedCategories throws PreferenceUpdateException on unexpected error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFollowedCategories())
            .thenThrow(tException);
        // Act & Assert
            .thenThrow(PreferenceNotFoundException('')); // Simulate empty
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1))
            .thenAnswer((_) async {});
        // Act
        await historyRepository.addHeadlineToHistory(tHeadline1);
        // Assert
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1))
            .called(1);
        verifyNever(
          () => mockPreferencesClient.removeHeadlineToHistory(any()),
        );
      });

      test('addHeadlineToHistory adds item when history is below limit',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenAnswer((_) async => [tHeadline1]); // History has 1 item
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline2))
            .thenAnswer((_) async {});
        // Act
        await historyRepository.addHeadlineToHistory(tHeadline2);
        // Assert
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline2))
            .called(1);
        verifyNever(
          () => mockPreferencesClient.removeHeadlineToHistory(any()),
        ); // Limit is 2, no removal needed
      });

      test('addHeadlineToHistory moves existing item to top', () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenAnswer((_) async => [tHeadline1, tHeadline2]);
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1))
            .thenAnswer((_) async {}); // Adding tHeadline1 again
        // Act
        await historyRepository.addHeadlineToHistory(tHeadline1);
        // Assert
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1))
            .called(1);
        verifyNever(
          () => mockPreferencesClient.removeHeadlineToHistory(any()),
        ); // No removal needed as size is still 2
      });

      test('addHeadlineToHistory adds new and removes oldest when at limit',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenAnswer((_) async => [tHeadline1, tHeadline2]); // At limit (2)
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline3))
            .thenAnswer((_) async {});
        when(() => mockPreferencesClient.removeHeadlineToHistory(tHeadline2.id)) // tHeadline2 is oldest
            .thenAnswer((_) async {});
        // Act
        await historyRepository.addHeadlineToHistory(tHeadline3);
        // Assert
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline3))
            .called(1);
        verify(() => mockPreferencesClient.removeHeadlineToHistory(tHeadline2.id))
            .called(1); // Verify oldest was removed
      });

       test('addHeadlineToHistory handles fetch error gracefully', () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenThrow(PreferenceUpdateException('Fetch failed'));
        // Act & Assert
        await expectLater(
          historyRepository.addHeadlineToHistory(tHeadline1),
          throwsA(isA<PreferenceUpdateException>()), // Expect the fetch error to propagate
        );
        // Verify interactions
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verifyNever(() => mockPreferencesClient.addHeadlineToHistory(any()));
        verifyNever(() => mockPreferencesClient.removeHeadlineToHistory(any()));
      });

      test('addHeadlineToHistory handles add error gracefully', () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenAnswer((_) async => []); // History is empty
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1))
            .thenThrow(PreferenceUpdateException('Add failed')); // Add fails
        // Act & Assert
        await expectLater(
          historyRepository.addHeadlineToHistory(tHeadline1),
          throwsA(isA<PreferenceUpdateException>()), // Expect the add error to propagate
        );
        // Verify interactions
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline1)).called(1);
        verifyNever(() => mockPreferencesClient.removeHeadlineToHistory(any()));
      });

       test('addHeadlineToHistory ignores remove error when trimming', () async {
        // Arrange
        when(() => mockPreferencesClient.getHeadlineReadingHistory())
            .thenAnswer((_) async => [tHeadline1, tHeadline2]); // At limit (2)
        when(() => mockPreferencesClient.addHeadlineToHistory(tHeadline3))
            .thenAnswer((_) async {}); // Add succeeds
        when(() => mockPreferencesClient.removeHeadlineToHistory(tHeadline2.id)) // tHeadline2 is oldest
            .thenThrow(PreferenceUpdateException('Remove failed')); // Remove fails
        // Act & Assert
        // Should complete successfully despite the remove error
        await expectLater(
          historyRepository.addHeadlineToHistory(tHeadline3),
          completes,
        );
        // Verify interactions
        verify(() => mockPreferencesClient.getHeadlineReadingHistory()).called(1);
        verify(() => mockPreferencesClient.addHeadlineToHistory(tHeadline3))
            .called(1);
        verify(() => mockPreferencesClient.removeHeadlineToHistory(tHeadline2.id))
            .called(1); // Verify remove was attempted
      });


      test('removeHeadlineToHistory completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.removeHeadlineToHistory('h1'))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          historyRepository.removeHeadlineToHistory('h1'),
          completes,
        );
        verify(() => mockPreferencesClient.removeHeadlineToHistory('h1'))
            .called(1);
      });

      test(
          'removeHeadlineToHistory throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.removeHeadlineToHistory('h1'))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          historyRepository.removeHeadlineToHistory('h1'),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.removeHeadlineToHistory('h1'))
            .called(1);
      });
    });

    // --- FeedSettings ---
    group('FeedSettings', () {
      final tFeedSettings =
          FeedSettings(feedListTileType: FeedListTileType.imageStart);

      test('getFeedSettings returns settings on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getFeedSettings())
            .thenAnswer((_) async => tFeedSettings);
        // Act
        final result = await repository.getFeedSettings();
        // Assert
        expect(result, tFeedSettings);
        verify(() => mockPreferencesClient.getFeedSettings()).called(1);
      });

      test('getFeedSettings throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getFeedSettings())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getFeedSettings(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getFeedSettings()).called(1);
      });

      test('setFeedSettings completes on success', () async {
        // Arrange
        when(() => mockPreferencesClient.setFeedSettings(tFeedSettings))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setFeedSettings(tFeedSettings),
          completes,
        );
        verify(() => mockPreferencesClient.setFeedSettings(tFeedSettings))
            .called(1);
      });

      test('setFeedSettings throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.setFeedSettings(tFeedSettings))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setFeedSettings(tFeedSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() => mockPreferencesClient.setFeedSettings(tFeedSettings))
            .called(1);
      });
    });

    // --- NotificationSettings ---
    group('NotificationSettings', () {
      final tNotificationSettings = NotificationSettings(
        enabled: true,
        categoryNotifications: ['c1'],
        sourceNotifications: ['s1'],
        followedEventCountryIds: ['co1'],
      );

      test('getNotificationSettings returns settings on success', () async {
        // Arrange
        when(() => mockPreferencesClient.getNotificationSettings())
            .thenAnswer((_) async => tNotificationSettings);
        // Act
        final result = await repository.getNotificationSettings();
        // Assert
        expect(result, tNotificationSettings);
        verify(() => mockPreferencesClient.getNotificationSettings()).called(1);
      });

      test(
          'getNotificationSettings throws PreferenceNotFoundException on client error',
          () async {
        // Arrange
        when(() => mockPreferencesClient.getNotificationSettings())
            .thenThrow(PreferenceNotFoundException('Not found'));
        // Act & Assert
        await expectLater(
          repository.getNotificationSettings(),
          throwsA(isA<PreferenceNotFoundException>()),
        );
        verify(() => mockPreferencesClient.getNotificationSettings()).called(1);
      });

      test('setNotificationSettings completes on success', () async {
        // Arrange
        when(() =>
                mockPreferencesClient.setNotificationSettings(tNotificationSettings))
            .thenAnswer((_) async {});
        // Act & Assert
        await expectLater(
          repository.setNotificationSettings(tNotificationSettings),
          completes,
        );
        verify(() =>
                mockPreferencesClient.setNotificationSettings(tNotificationSettings))
            .called(1);
      });

      test(
          'setNotificationSettings throws PreferenceUpdateException on client error',
          () async {
        // Arrange
        when(() =>
                mockPreferencesClient.setNotificationSettings(tNotificationSettings))
            .thenThrow(PreferenceUpdateException('Update failed'));
        // Act & Assert
        await expectLater(
          repository.setNotificationSettings(tNotificationSettings),
          throwsA(isA<PreferenceUpdateException>()),
        );
        verify(() =>
                mockPreferencesClient.setNotificationSettings(tNotificationSettings))
            .called(1);
      });
    });
  });
}
