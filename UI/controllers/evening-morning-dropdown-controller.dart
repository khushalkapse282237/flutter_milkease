import 'package:get/get.dart';

class EveningMorningController extends GetxController{
  RxString selectedValue = 'Morning'.obs;

  List<String> EveningMorningOptions =[
    'Morning',
    'Evening',
  ];
  void changeValue(String newValue){
    selectedValue.value = newValue;
    print(selectedValue.value);
  }
}