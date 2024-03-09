import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:milky_ease/BACKEND/services/detailed-customer-info-services.dart';
import 'package:milky_ease/UI/const/themes.dart';
import 'package:milky_ease/UI/screens/add-detailed-customer-info.dart';

import '../../BACKEND/models/detailed-customer-info-model.dart';

class DetailedCustomerInfo extends StatefulWidget {
  final String name;
  final String litre;
  final String price;
  final String phase;
  final String id;

  const DetailedCustomerInfo(
      {Key? key,
      required this.name,
      required this.litre,
      required this.price,
      required this.phase,
      required this.id})
      : super(key: key);

  @override
  State<DetailedCustomerInfo> createState() => _DetailedCustomerInfoState();
}

class _DetailedCustomerInfoState extends State<DetailedCustomerInfo> {
  late DetailedCustomerInfoService detailedCustomerInfoService;
  late double cost=0;
  @override
  void initState() {
    super.initState();
    detailedCustomerInfoService = DetailedCustomerInfoService(widget.id);
    updateTotalCost();
  }
  Future<void> updateTotalCost() async {
    double? totalCost = await detailedCustomerInfoService.getTotalCost();
    setState(() {
      cost = totalCost ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: headingStyle,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await detailedCustomerInfoService.deleteCollection();
              _refreshData();
            },
            icon: const Icon(Icons.delete, color: Colors.black),
          ),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: FutureBuilder<List<DetailedCustomerInfoModel>>(
        future: detailedCustomerInfoService.getDetailedCustomerInfo(),
        builder:
            (context, AsyncSnapshot<List<DetailedCustomerInfoModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Sr\nNo.')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Litre')),
                      DataColumn(label: Text('Phase')),
                      DataColumn(label: Text('Cost')),
                      DataColumn(label: Text(' ')),
                    ],
                    columnSpacing: MediaQuery.of(context).size.width * 0.047,
                    rows: snapshot.data!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final customer = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(customer.date)),
                          DataCell(Text(customer.litre)),
                          DataCell(Text(customer.phase)),
                          DataCell(Text(customer.cost)),
                          DataCell(TextButton(
                              onPressed: () async {

                                String? a;
                                a  = await detailedCustomerInfoService.getDocumentIdByDateAndPhase(customer.date, customer.phase);
                                await detailedCustomerInfoService.deleteDocument(a!);
                                _refreshData();
                              },
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.black,
                              ))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Total Cost : $cost",style: subHeadingStyle.copyWith(color: Colors.black),),
                      )),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddDetailedCustomerInfo(
                litre: widget.litre,
                price: widget.price,
                phase: widget.phase,
                id: widget.id,
              ));
        },
        backgroundColor: Themes.mainColor,
        child: Icon(
          Icons.add,
          color: Themes.darkColor,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    updateTotalCost();
    setState(() {});
  }
}
