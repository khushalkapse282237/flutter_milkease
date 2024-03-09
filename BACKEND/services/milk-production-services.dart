import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/milk-production-model.dart';

class MilkProductionServices {

    var customerDbRef = FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email!
        .toString())
        .collection("milk-production");

  Future<void> setToDB(int noOfCows, double totalMilk, double fat,String phase,String date) async {
    try {
      await customerDbRef
          .add(MilkProductionModel(
        noOfCows: noOfCows,
        totalMilk: totalMilk,
        fat: fat,
        phase: phase,
        date: date,)
          .toMap())
          .catchError((e) {
        debugPrint(e);
        return {'error': e} as DocumentReference<Map<String, dynamic>>;
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<List<MilkProductionModel>> getMilkProduction() async{
    try{
      var querySnapshot = await customerDbRef.orderBy('date').get();

      List<MilkProductionModel> res = [];
      for (var doc in querySnapshot.docs) {
        res.add(MilkProductionModel.fromMap(doc.data()));
      }
      return res;
    }catch(e){
      debugPrint(e.toString());
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
          // No document found with the provided date and phase
          return null;
        }
      } catch (e) {
        print('Error getting document ID: $e');
        return null;
      }
    }

    Future<void> deleteDocumentById(String documentId) async {
      try {
        // Create a reference to the document using its ID
        var documentRef = customerDbRef.doc(documentId);

        // Delete the document
        await documentRef.delete();
      } catch (e) {
        print('Error deleting document: $e');
        throw e; // Rethrow the error to handle it elsewhere if needed
      }
    }

    Future<List<String>> getColumnDates() async {
      try {
        var querySnapshot = await customerDbRef.orderBy('date').get();
        List<String> dates = [];
        for (var doc in querySnapshot.docs) {
          dates.add(doc['date']);
        }
        return dates;
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }

    Future<List<double>> getColumnTotalMilk() async {
      try {
        var querySnapshot = await customerDbRef.orderBy('date').get();
        List<double> dates = [];
        for (var doc in querySnapshot.docs) {
          dates.add(doc['totalMilk']);
        }
        return dates;
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }

    Future<void> deleteMilkProductionCollection() async {
      try {
        await customerDbRef.get().then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      } catch (e) {
        print('Error deleting collection: $e');
        throw e;
      }
    }
}
