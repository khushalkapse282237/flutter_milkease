import 'package:get/get.dart';

class BandiLitreController extends GetxController{
  RxString bandiLitre = '1'.obs;
  List<String> bandiLitreOptions = [
    '0.100','0.200','0.250','0.500','0.750','1',
    '1.25','1.5','1.75','2',
    '2.25','2.5','2.75','3',
    '3.25','3.5','3.75','4',
    '4.25','4.5','4.75','5',
    '5.25','5.5','5.75','6'
  ];
  void changeValue(String newValue){
    bandiLitre.value = newValue;
    print(bandiLitre.value);
  }
}