import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky_ease/BACKEND/services/customer-services.dart';
import '../const/themes.dart';
import '../controllers/bandi-litre-dropdown-controller.dart';
import '../controllers/evening-morning-dropdown-controller.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  TextEditingController customerName = TextEditingController();
  TextEditingController bandiPrice = TextEditingController();
  final bandiLitreController = Get.put(BandiLitreController());
  String startDate = DateTime.now().toString().substring(0, 11);
  String endDate =
      DateTime.now().add(const Duration(days: 30)).toString().substring(0, 11);
  final eveninMorningController =
  Get.put(EveningMorningController(), permanent: false);
  CustomerServices customerServices = CustomerServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.lightColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Add Customer",
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
                controller: customerName,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter name of customer",
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
                controller: bandiPrice,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Enter Price",
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
                    items: bandiLitreController.bandiLitreOptions
                        .map((String e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) {
                      bandiLitreController.changeValue(newValue!);
                    },
                    underline: Container(),
                  ),
                  context),
              const SizedBox(
                height: 20,
              ),
              containerWithWidget1(
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
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   border: Border.all(width: 1, color: Themes.darkColor),
                    // ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                            'Start Date',
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
                            if (picked != null && picked != startDate) {
                              setState(() {
                                startDate = picked.toString().substring(0, 11);
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
                              Text(startDate),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   border: Border.all(width: 1, color: Themes.darkColor),
                    // ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                            'End Date',
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
                            if (picked != null && picked != endDate) {
                              setState(() {
                                endDate = picked.toString().substring(0, 11);
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
                              Text(endDate),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    if (customerName.text.isNotEmpty &&
                        bandiPrice.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Customer is added',
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                      customerServices.setToDB(

                          customerName.text.trim(),
                          bandiLitreController.bandiLitre.value,
                          bandiPrice.text.trim(),
                          eveninMorningController.selectedValue.value,
                          startDate,
                          endDate);
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
                    "Add",
                    style: titleStyle,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerWithWidget(Widget widget, BuildContext context) {
    RxBool hover = false.obs;
    return Obx(() => MouseRegion(
          child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.078,
              decoration: BoxDecoration(
                  // color: Colors.white,
                  border: Border.all(
                      color: hover.value ? Colors.grey : Themes.darkColor,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  ${bandiLitreController.bandiLitre}',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  widget
                ],
              )),
        ));
  }

  Widget containerWithWidget1(Widget widget, BuildContext context) {
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
