import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky_ease/BACKEND/services/milk-production-services.dart';
import 'package:milky_ease/UI/const/themes.dart';

import '../controllers/evening-morning-dropdown-controller.dart';

class AddMilkProduction extends StatefulWidget {
  const AddMilkProduction({super.key});

  @override
  State<AddMilkProduction> createState() => _AddMilkProductionState();
}

class _AddMilkProductionState extends State<AddMilkProduction> {
  TextEditingController todaysTotalMilk = TextEditingController();
  TextEditingController todaysTotalCows = TextEditingController();
  TextEditingController todaysFat = TextEditingController();
  String todayDate = DateTime.now().toString().substring(0, 11);
  final eveninMorningController =
      Get.put(EveningMorningController(), permanent: false);
  MilkProductionServices milkProductionServices = MilkProductionServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.lightColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Add milk Production",
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: todaysTotalCows,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter total no. of cows",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Themes.darkColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Themes.mainColor),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: todaysTotalMilk,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter total milk in litre",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Themes.darkColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Themes.mainColor),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: todaysFat,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter fat",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Themes.darkColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Themes.mainColor),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              containerWithWidget(
                  DropdownButton(
                    items: eveninMorningController.EveningMorningOptions.map(
                            (String e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) {
                      eveninMorningController.changeValue(newValue!);
                    },
                    underline: Container(),
                  ),
                  context),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                            "Today's Date",
                            style:
                                bodyStyle.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2040),
                            );
                            if (picked != null && picked != todayDate) {
                              setState(() {
                                todayDate = picked.toString().substring(0, 11);
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Color(0xFF8AEF8A),
                              ),
                              Text(todayDate),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (todaysTotalCows.text.isNotEmpty &&
                        todaysTotalMilk.text.isNotEmpty &&
                        todayDate.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Entry is added',
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                      int totalCows = int.tryParse(todaysTotalCows.text) ?? 0;
                      double totalMilk =
                          double.tryParse(todaysTotalMilk.text) ?? 0.0;
                      double fat = double.tryParse(todaysFat.text) ?? 0.0;
                      milkProductionServices.setToDB(
                          totalCows,
                          totalMilk,
                          todaysFat.text.isNotEmpty? fat:0,
                          eveninMorningController.selectedValue.value,
                          todayDate);
                      Get.back();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields.',
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Submit",
                    style: titleStyle,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerWithWidget(Widget widget, BuildContext context) {
    RxBool hovering = false.obs;
    return Obx(() => MouseRegion(
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.078,
              decoration: BoxDecoration(
                  // color: Colors.white,
                  border: Border.all(
                      color: hovering.value ? Colors.grey : Themes.darkColor,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  ${eveninMorningController.selectedValue}',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  widget
                ],
              )),
        ));
  }
}
