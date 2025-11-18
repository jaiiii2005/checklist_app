import 'package:cloud_firestore/cloud_firestore.dart';
import '../ models/item.dart';
import '../ models/trip.dart';
import '../ models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🧍 Save user info when they sign up
  Future<void> saveUser(AppUser user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  /// 💼 Create a new trip document for the user
  Future<void> createTrip(String uid, Trip trip) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(trip.id)
        .set(trip.toMap());
  }

  /// 📦 Fetch all trips for a user
  Future<List<Trip>> getTrips(String uid) async {
    final snapshot =
    await _db.collection('users').doc(uid).collection('trips').get();

    return snapshot.docs
        .map((doc) => Trip.fromMap(doc.data()))
        .toList();
  }

  /// 🔄 Update progress or checklist items
  Future<void> updateTrip(String uid, Trip trip) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(trip.id)
        .update(trip.toMap());
  }

  /// 🗑️ Delete a trip
  Future<void> deleteTrip(String uid, String tripId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .delete();
  }

  /// 🧾 Save a new checklist item
  Future<void> addChecklistItem(String uid, String tripId, Item item) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('items')
        .add(item.toMap());
  }

  /// 📥 Fetch all checklist items for a trip
  Future<List<Item>> getChecklistItems(String uid, String tripId) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('items')
        .get();

    return snapshot.docs
        .map((doc) => Item.fromMap(doc.data()))
        .toList();
  }
}
