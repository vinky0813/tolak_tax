import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tolak_tax/data/achievement_definitions.dart';
import 'package:tolak_tax/models/achievement_model.dart';

class AchievementService with ChangeNotifier {
  int _totalPoints = 0;
  late final String _fileName;
  Map<String, AchievementProgress> _userAchievements = {};
  bool _isInitialized = false;

  // getter for these private variables
  int get totalPoints => _totalPoints;
  Map<String, AchievementProgress> get userAchievements => _userAchievements;
  bool get isInitialized => _isInitialized;
  String get fileName => _fileName;

  AchievementService({required String uid}) {
    assert(uid.isNotEmpty, 'AchievementService requires a valid user ID.');
    _fileName = 'user_achievements_$uid.json';

    initialize();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadUserAchievements();
    _isInitialized = true;
    notifyListeners();
  }

  // used in initialization
  Future<void> _loadUserAchievements() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    bool needsSave = false;

    // if there is no progress file then just start with empty progress
    if (await file.exists() == false) {
      _userAchievements = {
        for (var def in allAchievementDefinitions)
          def.id: AchievementProgress(achievementId: def.id)
      };
      _totalPoints = 0;
      needsSave = true;
    } else {
      final content = await file.readAsString();
      if (content.isEmpty) {
        _userAchievements = {
          for (var def in allAchievementDefinitions)
            def.id: AchievementProgress(achievementId: def.id)
        };
        _totalPoints = 0;
        needsSave = true;
      } else {
        final data = Map<String, dynamic>.from(json.decode(content));
        _totalPoints = data['totalPoints'] ?? 0;
        final progressList = (data['progress'] as List)
            .map((item) => AchievementProgress.fromJson(item))
            .toList();
        _userAchievements = {for (var p in progressList) p.achievementId: p};
      }
    }

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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  // used in updateProgress()
  Future<void> _saveUserAchievements() async {
    // write the update to JSON
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');
    final data = {
      'totalPoints': totalPoints,
      'progress': userAchievements.values.map((p) => p.toJson()).toList(),
    };
    await file.writeAsString(json.encode(data));
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
        _totalPoints += relAchievement.pointsReward;
        unlockedAchievements.add(relAchievement);
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
}
