import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/detailed-customer-info-model.dart';

class DetailedCustomerInfoService {
  final String id;
  var customerDbRef ;

  DetailedCustomerInfoService(this.id) {
    customerDbRef = FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!
        .toString())
        .collection("customers").doc(id).collection("data");
  }

  Future<void> setToDB(String date, String litre, String cost,String phase) async {
    try {
      await customerDbRef
          .add(DetailedCustomerInfoModel(
          date: date,
          litre: litre,
          cost: cost,
          phase: phase,)
          .toMap())
          .catchError((e) {
        debugPrint(e);
        return {'error': e} as DocumentReference<Map<String, dynamic>>;
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<List<DetailedCustomerInfoModel>> getDetailedCustomerInfo() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('date').get();

      List<DetailedCustomerInfoModel> res = [];
      querySnapshot.docs.forEach((doc) {
        res.add(DetailedCustomerInfoModel.fromMap(doc.data() as Map<String, dynamic>));
      });
      return res;
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> deleteCollection() async {
    try {
      var querySnapshot = await customerDbRef.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Error deleting collection: $e");
      rethrow;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await customerDbRef.doc(documentId).delete();
    } catch (e) {
      print("Error deleting document: $e");
      rethrow;
    }
  }

  Future<String?> getDocumentIdByDateAndPhase(String date, String phase) async {
    try {
      var querySnapshot = await customerDbRef
          .where('date', isEqualTo: date)
          .where('phase', isEqualTo: phase)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting document ID: $e");
      rethrow;
    }
  }

  Future<double?> getTotalCost() async {
    try {
      double totalCost = 0.0; // Use double instead of int for totalCost

      var querySnapshot = await customerDbRef.get();

      for (var doc in querySnapshot.docs) {
        var costValue = doc.get('cost');
        if (costValue != null) {
          // Parse the cost value as double instead of int
          totalCost += double.tryParse(costValue.toString()) ?? 0.0;
        }
      }

      print("Total cost: $totalCost");
      return totalCost;
    } catch (e) {
      print("Error calculating total cost: $e");
      return null;
    }
  }




}
