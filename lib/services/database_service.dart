// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ models/item.dart';
import '../ models/trip.dart';



class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or merge user doc
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(data, SetOptions(merge: true));
  }

  // Add trip and return generated id
  Future<String> addTrip(String uid, Trip trip) async {
    final docRef = _db.collection("users").doc(uid).collection("trips").doc();
    trip.id = docRef.id;
    await docRef.set(trip.toMap());
    return docRef.id;
  }

  // Get all trips for user as stream
  Stream<List<Trip>> getTrips(String uid) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .snapshots()
        .map((snap) => snap.docs.map((d) {
      final map = Map<String, dynamic>.from(d.data());
      final trip = Trip.fromMap(map);
      trip.id = d.id;
      return trip;
    }).toList());
  }

  // Get items for a trip as stream
  Stream<List<Item>> getTripItems(String uid, String tripId) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(tripId)
        .collection("items")
        .snapshots()
        .map((snap) => snap.docs.map((d) {
      final map = Map<String, dynamic>.from(d.data());
      final item = Item.fromMap(map);
      item.id = d.id;
      return item;
    }).toList());
  }

  // Add or update an item inside a trip (use item.name as doc id to avoid duplicates)
  Future<void> addOrUpdateItem(String uid, String tripId, Item item) async {
    final docRef = _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(tripId)
        .collection("items")
        .doc(item.name); // name-based id

    await docRef.set(item.toMap(), SetOptions(merge: true));
  }

  // Find a trip by purpose (returns trip id or null)
  Future<String?> findTripByPurpose(String uid, String purpose) async {
    final snap = await _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .where("purpose", isEqualTo: purpose)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }

  // Update progress of an existing trip
  Future<void> updateTripProgress(String uid, String tripId, double progress) async {
    await _db.collection("users").doc(uid).collection("trips").doc(tripId).update({
      "progress": progress,
    });
  }
  // 🔥 Get all trip items once (NOT a stream)
  Future<List<Item>> getTripItemsOnce(String uid, String tripId) async {
    final snap = await _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(tripId)
        .collection("items")
        .get();

    return snap.docs.map((d) => Item.fromMap(d.data())).toList();
  }

}
