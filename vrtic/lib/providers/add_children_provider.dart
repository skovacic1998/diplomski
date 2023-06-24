import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChildNameNotifier extends StateNotifier<String>{
  ChildNameNotifier() : super("");

  void replaceChildName(String string){
    state = string;
  }
}
class ChildSurnameNotifer extends StateNotifier<String>{
  ChildSurnameNotifer() : super("");

  void replaceChildSurname(String string){
    state = string;
  }
}


final childNameProvider = StateNotifierProvider<ChildNameNotifier, String>((ref) => ChildNameNotifier());
final childSurnameProvider = StateNotifierProvider<ChildSurnameNotifer, String>((ref) => ChildSurnameNotifer());
final childTypeProvider = StateProvider.autoDispose<int>((ref) => 0);
final textEditingControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());