import 'package:flutter/material.dart';
import 'package:milky_ease/BACKEND/models/customer-model.dart';
import 'package:milky_ease/BACKEND/services/customer-services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:milky_ease/UI/screens/detailed-customer-info.dart';
import '../const/themes.dart';
import 'add-customer.dart';
import 'dashboard.dart';
import 'login.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomerServices customerServices = CustomerServices();
  String _selectedSortOption = 'Start Date';

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
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Themes.mainColor,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_rounded,
                color: Themes.darkColor,
              ),
            ),
          ),
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
                'Customer',
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildFilterUI(),
            FutureBuilder<List<CustomerModel>>(
              future: _getSortedCustomerList(),
              builder:
                  (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
                        columns: const [
                          DataColumn(label: Text('Sr\nNo.')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Bandi Litre')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Phase')),
                          DataColumn(label: Text('Start Date')),
                          DataColumn(label: Text('End Date')),
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('')),
                        ],
                        columnSpacing:
                            MediaQuery.of(context).size.width * 0.05,
                        rows: snapshot.data!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final customer = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(Text((index + 1).toString())),
                              DataCell(Text(customer.name)),
                              DataCell(Text(customer.litre)),
                              DataCell(Text(customer.price)),
                              DataCell(Text(customer.phase)),
                              DataCell(Text(customer.startDate)),
                              DataCell(Text(customer.endDate)),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    Get.to(()=>DetailedCustomerInfo(
                                        name: customer.name,
                                        litre: customer.litre,
                                        price: customer.price,
                                        phase: customer.phase,
                                        id: customer.id,));
                                  },
                                  child: const Text('More...',style:TextStyle(color: Colors.black),),
                                ),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    await customerServices.deleteCustomer(customer.id);
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.delete_outline_rounded,color: Colors.black,),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddCustomer());
        },
        backgroundColor: Themes.mainColor,
        child: Icon(
          Icons.add,
          color: Themes.darkColor,
        ),
      ),
    );
  }

  Widget _buildFilterUI() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Sort By:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<String>(
            value: _selectedSortOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSortOption = newValue!;
              });
            },
            items: <String>['Start Date', 'End Date', 'Name', 'Phase']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Future<List<CustomerModel>> _getSortedCustomerList() async {
    switch (_selectedSortOption) {
      case 'Start Date':
        return customerServices.getCustomerSortByStartDate();
      case 'End Date':
        return customerServices.getCustomerSortByEndDate();
      case 'Name':
        return customerServices.getCustomerSortByName();
      case 'Phase':
        return customerServices.getCustomerSortByPhase();
      default:
        return customerServices.getCustomerSortByStartDate();
    }
  }
}
