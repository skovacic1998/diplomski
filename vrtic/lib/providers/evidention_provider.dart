
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateTimeProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

final selectedChildrenProvider = StateProvider.autoDispose<List<int>>((ref) => []);
final selectedChildrenObjectsProvider = StateProvider.autoDispose<List<Map<String,dynamic>>>((ref) => []);