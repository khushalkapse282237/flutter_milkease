import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:milky_ease/BACKEND/models/customer-model.dart';

class CustomerServices {
  var customerDbRef = FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser!.email!
      .toString())
      .collection("customers");
  Future<void> setToDB(String name, String litre, String price, String phase,
      String startDate, String endDate) async {
    try {
      String id = generateUniqueId(); // Generate a unique ID
      await customerDbRef
          .doc(id) // Use the generated ID as the document ID
          .set(CustomerModel(
          id: id, // Pass the generated ID to the CustomerModel
          name: name,
          litre: litre,
          price: price,
          phase: phase,
          startDate: startDate,
          endDate: endDate)
          .toMap());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }


  Future<List<CustomerModel>> getCustomer() async {
    try {
      var querySnapshot = await customerDbRef.get();

      List<CustomerModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(CustomerModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      });
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }


  Future<List<CustomerModel>> getCustomerSortByStartDate() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('startDate').get();

      List<CustomerModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(CustomerModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      });
      return res;
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<CustomerModel>> getCustomerSortByEndDate() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('endDate').get();

      List<CustomerModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(CustomerModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      });
      return res;
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<CustomerModel>> getCustomerSortByName() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('name').get();

      List<CustomerModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(CustomerModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      });
      return res;
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<List<CustomerModel>> getCustomerSortByPhase() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('phase',descending: true).get();

      List<CustomerModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(CustomerModel.fromMap(doc.id, doc.data() as Map<String, dynamic>));
      });
      return res;
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  String generateUniqueId() {
    const String chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const int length = 20; // Length of the generated ID

    Random random = Random();
    String id = '';

    for (int i = 0; i < length; i++) {
      id += chars[random.nextInt(chars.length)];
    }

    return id;
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await customerDbRef.doc(customerId).delete();
    } catch (e) {
      debugPrint("Error deleting customer: $e");
      rethrow;
    }
  }
}
