import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky_ease/BACKEND/services/detailed-customer-info-services.dart';
import '../const/themes.dart';
import '../controllers/bandi-litre-dropdown-controller.dart';
import '../controllers/evening-morning-dropdown-controller.dart';

class AddDetailedCustomerInfo extends StatefulWidget {
  final String litre;
  final String price;
  final String phase;
  final String id;

  const AddDetailedCustomerInfo(
      {Key? key, required this.litre,required this.phase, required this.price,required this.id})
      : super(key: key);

  @override
  State<AddDetailedCustomerInfo> createState() =>
      _AddDetailedCustomerInfoState();
}

class _AddDetailedCustomerInfoState extends State<AddDetailedCustomerInfo> {
  TextEditingController bandiPrice = TextEditingController();
  final bandiLitreController = Get.put(BandiLitreController());
  String todayDate = DateTime.now().toString().substring(0, 11);
  late DetailedCustomerInfoService detailedCustomerInfoService;
  final eveninMorningController =
  Get.put(EveningMorningController(), permanent: false);
  @override
  void initState() {
    super.initState();
    bandiLitreController.changeValue(widget.litre);
    detailedCustomerInfoService = DetailedCustomerInfoService(widget.id);
    updateCost();
    bandiLitreController.bandiLitre.listen((newValue) {
      updateCost();
    });
    eveninMorningController.changeValue(widget.phase);
  }

  void updateCost() {
    double totalPrice = double.parse(widget.price) * double.parse(bandiLitreController.bandiLitre.value);
    setState(() {
      bandiPrice.text = totalPrice.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.lightColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Add Today's Milk",
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
                readOnly: true,
                controller: bandiPrice,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: "Cost",
                  labelStyle: subHeadingStyle,
                  hintText: widget.price,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: Themes.darkColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Themes.mainColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                context,
              ),

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
              ElevatedButton(
                onPressed: () {
                  if (bandiPrice.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Milk is added',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                    detailedCustomerInfoService.setToDB(todayDate,
                        bandiLitreController.bandiLitre.value, bandiPrice.text.toString(),eveninMorningController.selectedValue.value);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerWithWidget(Widget widget, BuildContext context) {
    RxBool hover = false.obs;
    return Obx(() => MouseRegion(
          onEnter: (_) => hover.value = true,
          onExit: (_) => hover.value = false,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.078,
            decoration: BoxDecoration(
              border: Border.all(
                color: hover.value ? Colors.grey : Themes.darkColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  ${bandiLitreController.bandiLitre}',
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                widget,
              ],
            ),
          ),
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
