import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:milky_ease/BACKEND/services/milk-production-services.dart';
import 'package:milky_ease/UI/screens/add-milk-production.dart';

import '../../BACKEND/models/milk-production-model.dart';
import '../const/themes.dart';
import 'customer.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MilkProductionServices milkProductionServices = MilkProductionServices();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(
          "Milky Ease",
          style: headingStyle,
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Themes.darkColor,
            )),
        actions: [
          CircleAvatar(
              backgroundColor: Themes.mainColor,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person_rounded,
                    color: Themes.darkColor,
                  ))),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Themes.mainColor,
              ),
              child: Text('Menu', style: subHeadingStyle),
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: Themes.darkColor,
              ),
              title: Text(
                'DashBoard',
                style: titleStyle,
              ),
              onTap: () {
                Get.off(() => const Dashboard());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Themes.darkColor,
              ),
              title: Text(
                'Customers',
                style: titleStyle,
              ),
              onTap: () {
                Get.off(() => const Customer());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Themes.darkColor,
              ),
              title: Text(
                'Logout',
                style: titleStyle,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              },
            ),
          ],
        ),
      ),
      body: _buildBody(),
      // Display Histogram
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const AddMilkProduction());
          },
          backgroundColor: Themes.mainColor,
          child: Icon(
            Icons.add,
            color: Themes.darkColor,
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.pie_chart),
          //   label: 'Pie Chart',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.line_axis_outlined),
            label: 'Line xGraph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Table',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Themes.mainColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
    // case 0:
    //   return _buildPieChart();
      case 0:
        return _buildLineChart();
      case 1:
        return _table();
      default:
        return Container();
    }
  }


  SingleChildScrollView _table() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<MilkProductionModel>>(
        future: milkProductionServices.getMilkProduction(),
        builder:
            (context, AsyncSnapshot<List<MilkProductionModel>> snapshot) {
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: DataTable(
                  columns: <DataColumn>[
                    const DataColumn(label: Text('Sr\nNo.')),
                    const DataColumn(label: Text('Date')),
                    const DataColumn(label: Text('Phase')),
                    const DataColumn(label: Text('Total Cows')),
                    const DataColumn(label: Text('Litre')),
                    const DataColumn(label: Text('Fat')),
                    DataColumn(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(onPressed: (){
                            milkProductionServices.deleteMilkProductionCollection();
                            setState(() {});
                          }, icon: const Icon(Icons.delete,color: Colors.black,))
                        ],
                      ),
                    ),

                  ],
                  columnSpacing: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05,
                  rows: snapshot.data!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final milk = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(milk.date)),
                        DataCell(Text(milk.phase)),
                        DataCell(Text(milk.noOfCows.toString())),
                        DataCell(Text(milk.totalMilk.toString())),
                        DataCell(Text(milk.fat.toString())),
                        DataCell(
                          TextButton(
                            onPressed: () async {
                              String? a = await milkProductionServices
                                  .getDocumentIdByDateAndPhase(
                                  milk.date, milk.phase);
                              await milkProductionServices
                                  .deleteDocumentById(a!);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildPieChart() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: FutureBuilder<List<double>>(
  //       future: milkProductionServices.getColumnTotalMilk(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else {
  //           return PieChart(
  //             PieChartData(
  //               sections: List.generate(snapshot.data!.length, (index) {
  //                 return PieChartSectionData(
  //                   value: snapshot.data![index],
  //                   title: '${snapshot.data![index]}',
  //                   radius: 100,
  //                 );
  //               }),
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  Widget _buildLineChart() {
    // Function to generate random color
    Color getRandomColor() {
      final random = Random();
      return Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<List<String>>(
            future: milkProductionServices.getColumnDates(),
            // Call the method to get dates
            builder: (context, dateSnapshot) {
              if (dateSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (dateSnapshot.hasError) {
                return Center(child: Text('Error: ${dateSnapshot.error}'));
              } else {
                var dates = dateSnapshot.data ?? []; // Assign retrieved dates to the list

                return FutureBuilder<List<double>>(
                  future: milkProductionServices.getColumnTotalMilk(),
                  // Call the method to get total milk liters
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      var totalLitres = snapshot.data ?? []; // Assign retrieved total liters to the list

                      // Prepare data for the line chart
                      List<FlSpot> lineChartData = List.generate(
                        dates.length,
                            (index) {
                          return FlSpot(
                            index.toDouble(),
                            totalLitres[index], // Total liters of milk for the corresponding date
                          );
                        },
                      );

                      // Return the line chart widget
                      return AspectRatio(
                        aspectRatio: 1.5,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 10),
                                getTitles: (value) {
                                  // Split the date string
                                  List<String> dateParts = dates[value.toInt()].split('-');
                                  // Format the date as desired
                                  return '${dateParts[2]}\n${getMonthName(dateParts[1])}';
                                },
                                margin: 8,
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 10),
                                getTitles: (value) {
                                  int intValue = value.toInt();
                                  if (intValue == 0 || intValue % 10 == 0) {
                                    return intValue.toString();
                                  }
                                  return '';
                                },
                                margin: 8,
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: lineChartData,
                                isCurved: true,
                                colors: [getRandomColor()], // Assign random color
                                barWidth: 4, // Line width
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }



  String getMonthName(String monthNumber) {
    switch (monthNumber) {
      case '01':
        return 'Jan';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'May';
      case '06':
        return 'Jun';
      case '07':
        return 'Jul';
      case '08':
        return 'Aug';
      case '09':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
      default:
        return '';
    }
  }

  // Future<void> _handleRefresh() async {
  //   setState(() {});
  // }
}