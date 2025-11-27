import 'package:cloud_firestore/cloud_firestore.dart';
import '../ models/item.dart';
import '../ models/trip.dart';


class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(data, SetOptions(merge: true));
  }

  /// ADD TRIP
  Future<void> addTrip(String uid, Trip trip) async {
    final doc = _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(); // create unique trip id

    trip.id = doc.id;

    await doc.set(trip.toMap());
  }

  /// GET TRIPS STREAM
  Stream<List<Trip>> getTrips(String uid) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Trip.fromMap(doc.data()))
          .toList();
    });
  }

  /// ADD ITEM TO TRIP
  Future<void> addItem(String uid, String tripId, Item item) async {
    final doc = _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(tripId)
        .collection("items")
        .doc();

    item.id = doc.id;

    await doc.set(item.toMap());
  }

  /// GET ITEMS STREAM
  Stream<List<Item>> getItems(String uid, String tripId) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("trips")
        .doc(tripId)
        .collection("items")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.data()))
          .toList();
    });
  }
}
