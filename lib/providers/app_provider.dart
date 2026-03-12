import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  int _xp = 0;
  int _streak = 0;
  DateTime? _lastActivityDate;
  bool _isSeniorMode = false;
  bool _highContrast = false;
  double _fontSizeMultiplier = 1.0;
  Set<String> _completedLessons = {};
  Set<String> _earnedBadgeIds = {};

  int get xp => _xp;
  int get streak => _streak;
  bool get isSeniorMode => _isSeniorMode;
  bool get highContrast => _highContrast;
  double get fontSizeMultiplier => _fontSizeMultiplier;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get earnedBadgeIds => _earnedBadgeIds;

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('xp') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _isSeniorMode = prefs.getBool('isSeniorMode') ?? false;
    _highContrast = prefs.getBool('highContrast') ?? false;
    _fontSizeMultiplier = prefs.getDouble('fontSizeMultiplier') ?? 1.0;
    _completedLessons = (prefs.getStringList('completedLessons') ?? []).toSet();
    _earnedBadgeIds = (prefs.getStringList('earnedBadgeIds') ?? []).toSet();

    final lastActivityStr = prefs.getString('lastActivityDate');
    if (lastActivityStr != null) {
      _lastActivityDate = DateTime.parse(lastActivityStr);
      _checkStreak();
    }

    notifyListeners();
  }

  void _checkStreak() {
    if (_lastActivityDate == null) return;
    final now = DateTime.now();
    final difference = now.difference(_lastActivityDate!).inDays;
    if (difference > 1) {
      _streak = 0;
    }
  }

  Future<void> addXp(int amount) async {
    _xp += amount;
    _updateActivity();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    notifyListeners();
  }

  void _updateActivity() async {
    final now = DateTime.now();
    if (_lastActivityDate == null || now.difference(_lastActivityDate!).inDays == 1) {
      _streak++;
    } else if (now.difference(_lastActivityDate!).inDays > 1) {
      _streak = 1;
    }
    _lastActivityDate = now;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
    await prefs.setString('lastActivityDate', now.toIso8601String());
  }

  Future<void> setFontSizeMultiplier(double value) async {
    _fontSizeMultiplier = value;
    _isSeniorMode = value > 1.2;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSeniorMode', _isSeniorMode);
    await prefs.setDouble('fontSizeMultiplier', _fontSizeMultiplier);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', _highContrast);
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId) async {
    _completedLessons.add(lessonId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedLessons', _completedLessons.toList());
    notifyListeners();
  }

  Future<void> earnBadge(String badgeId) async {
    _earnedBadgeIds.add(badgeId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('earnedBadgeIds', _earnedBadgeIds.toList());
    notifyListeners();
  }
}
