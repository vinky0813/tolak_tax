import 'package:flutter/foundation.dart';
import 'package:tolak_tax/data/achievement_definitions.dart';
import 'package:tolak_tax/models/achievement_model.dart';
import 'package:tolak_tax/services/api_service.dart';
import 'package:tolak_tax/services/auth_service.dart';

class AchievementService with ChangeNotifier {

  final ApiService _apiService;
  final AuthService _authService;

  int _totalPoints = 0;
  Map<String, AchievementProgress> _userAchievements = {};
  bool _isInitialized = false;

  int _currentScanStreak = 0;
  DateTime? _lastScanTimestamp;

  // getter for these private variables
  int get totalPoints => _totalPoints;
  Map<String, AchievementProgress> get userAchievements => _userAchievements;
  bool get isInitialized => _isInitialized;
  int get currentScanStreak => _currentScanStreak;

  AchievementService({
    required ApiService apiService,
    required AuthService authService,
  })  : _apiService = apiService,
        _authService = authService {
    initialize();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadUserAchievements();
    _isInitialized = true;
    notifyListeners();
  }

  String getRankFromPoints() {
    if (_totalPoints >= 1500) {
      return 'Gold';
    }
    if (_totalPoints >= 1000) {
      return 'Silver';
    }
    if (_totalPoints >= 700) {
      return 'Bronze';
    }
    return 'Iron';
  }

  // used in initialization
  Future<void> _loadUserAchievements() async {
    try {
      final idToken = await _authService.getIdToken();
      final apiData = await _apiService.getAchievements(idToken);

      if (apiData == null) {
        _userAchievements = {
          for (var def in allAchievementDefinitions)
            def.id: AchievementProgress(achievementId: def.id)
        };
        _totalPoints = 0;
        _currentScanStreak = 0;
        _lastScanTimestamp = null;
        await _saveUserAchievements();

      } else {
        _totalPoints = apiData['totalPoints'] ?? 0;
        final progressList = (apiData['progress'] as List)
            .map((item) => AchievementProgress.fromJson(item))
            .toList();
        _userAchievements = {for (var p in progressList) p.achievementId: p};
        _currentScanStreak = apiData['currentScanStreak'] ?? 0;
        if (apiData['lastScanTimestamp'] != null) {
          _lastScanTimestamp = DateTime.parse(apiData['lastScanTimestamp']);
        }
      }
    } catch (e) {
      print('Error loading user achievements: $e');
      _userAchievements = {
        for (var def in allAchievementDefinitions)
          def.id: AchievementProgress(achievementId: def.id)
      };
      _totalPoints = 0;
      _currentScanStreak = 0;
      _lastScanTimestamp = null;
    }

    bool needsSave = false;

    for (final def in allAchievementDefinitions) {
      if (!_userAchievements.containsKey(def.id)) {
        _userAchievements[def.id] = AchievementProgress(achievementId: def.id);
        needsSave = true;
      }
    }

    if (needsSave) {
      await _saveUserAchievements();
    }
  }

  Future<void> deleteUserProgress() async {
    _userAchievements = {
      for (var def in allAchievementDefinitions)
        def.id: AchievementProgress(achievementId: def.id)
    };
    _totalPoints = 0;
    await _saveUserAchievements();
    notifyListeners();
    print('AchievementService: User progress has been reset.');
  }

  // used in updateProgress()
  Future<void> _saveUserAchievements() async {
    try {
      final idToken = await _authService.getIdToken();
      await _apiService.saveAchievements(
        idToken: idToken,
        totalPoints: _totalPoints,
        userAchievements: _userAchievements,
        currentScanStreak: _currentScanStreak,
        lastScanTimestamp: _lastScanTimestamp?.toIso8601String(),
      );
    } catch (e) {
      print('AchievementService ERROR on save: $e. Changes are not persisted on server.');
    }
  }

  final List<AchievementDefinition> _newlyUnlocked = [];
  List<AchievementDefinition> get newlyUnlocked => _newlyUnlocked;

  void clearNewlyUnlocked() {
    _newlyUnlocked.clear();
  }

  // call setAs to set the progress to a specific value
  // probably will be used for resetting scanning streak
  // isInternalCall can just ignore. its not even required let it be defaulted to false
  List<AchievementDefinition> updateProgress({
    required AchievementType type,
    double incrementBy = 0,
    double setAs = 0,
    bool isInternalCall = false,
  }) {
    final List<AchievementDefinition> unlockedAchievements = [];
    int pointsGainedThisUpdate = 0;
    bool wasChanged = false;

    // get all achievement of the same type and are not completed
    final relevantAchievement = allAchievementDefinitions.where((a) =>
        a.type == type && !(userAchievements[a.id]?.isCompleted ?? true));

    // add all the progress
    for (final relAchievement in relevantAchievement) {
      final userProgress = userAchievements[relAchievement.id]!;
      wasChanged = true;

      if (incrementBy > 0) {
        userProgress.progress += incrementBy;
      } else {
        userProgress.progress = setAs;
      }

      if (userProgress.progress >= relAchievement.goal) {
        userProgress.isCompleted = true;
        pointsGainedThisUpdate += relAchievement.pointsReward;
        unlockedAchievements.add(relAchievement);

        _newlyUnlocked.add(relAchievement);
      }
    }

    if (pointsGainedThisUpdate > 0) {
      _totalPoints += pointsGainedThisUpdate;

      print('[ACHIEVEMENT] Gained $pointsGainedThisUpdate points. Re-checking point-based achievements...');
      final unlockedByPoints = updateProgress(
        type: AchievementType.totalPoints,
        setAs: _totalPoints.toDouble(),
        isInternalCall: true,
      );

      unlockedAchievements.addAll(unlockedByPoints);
    }

    if (wasChanged && !isInternalCall) {
      // the local file shoudl be created on first update
      _saveUserAchievements();
      notifyListeners();
    }
    return unlockedAchievements;
  }

  Future<void> processDailyScan() async {
    final now = DateTime.now();
    final lastScan = _lastScanTimestamp;

    if (lastScan == null) {
      print("First scan ever. Starting streak at 1.");
      _currentScanStreak = 1;
    } else {
      final lastScanDate = DateTime(lastScan.year, lastScan.month, lastScan.day);
      final todayDate = DateTime(now.year, now.month, now.day);
      final yesterdayDate = todayDate.subtract(const Duration(days: 1));

      if (lastScanDate == todayDate) {
        print("Already scanned today. Streak remains at $_currentScanStreak.");
        return;
      } else if (lastScanDate == yesterdayDate) {
        _currentScanStreak++;
        print("Consecutive day scan! Streak is now $_currentScanStreak.");
      } else {
        print("Missed a day. Resetting streak to 1.");
        _currentScanStreak = 1;
      }
    }
    _lastScanTimestamp = now;
    await updateProgress(
      type: AchievementType.scanStreak,
      setAs: _currentScanStreak.toDouble(),
    );
  }
}
