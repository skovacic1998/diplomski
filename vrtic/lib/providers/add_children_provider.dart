import 'package:flutter_riverpod/flutter_riverpod.dart';

final childTypeProvider = StateProvider.autoDispose<int>((ref) => 0);