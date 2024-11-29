import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<void> fetchJoinedData() async {
//     try {
//       // Fetch cinemas
//       QuerySnapshot cinemaSnapshot = await _db.collection('cinemas').get();
//       List<Map<String, dynamic>> cinemas = cinemaSnapshot.docs
//           .map((doc) =>
//               {'cinema_id': doc.id, ...doc.data() as Map<String, dynamic>})
//           .toList();

//       // Fetch rooms and join with cinemas
//       QuerySnapshot roomSnapshot = await _db.collection('rooms').get();
//       List<Map<String, dynamic>> rooms = roomSnapshot.docs
//           .map((doc) =>
//               {'room_id': doc.id, ...doc.data() as Map<String, dynamic>})
//           .toList();

//       List<Map<String, dynamic>> joinedA = [];
//       for (var room in rooms) {
//         var cinema = cinemas.firstWhere(
//             (cinema) => cinema['cinema_id'] == room['cinema_id'],
//             orElse: () => {});
//         if (cinema.isNotEmpty) {
//           joinedA.add({
//             ...room,
//             'cinema': cinema,
//           });
//         }
//       }

//       // Fetch rounds and join with joinedA
//       QuerySnapshot roundSnapshot = await _db.collection('rounds').get();
//       List<Map<String, dynamic>> rounds = roundSnapshot.docs
//           .map((doc) =>
//               {'round_id': doc.id, ...doc.data() as Map<String, dynamic>})
//           .toList();

//       List<Map<String, dynamic>> joinedB = [];
//       for (var round in rounds) {
//         var room = joinedA.firstWhere(
//             (room) => room['room_id'] == round['room_id'],
//             orElse: () => {});
//         if (room.isNotEmpty) {
//           joinedB.add({
//             ...round,
//             'room': room,
//           });
//         }
//       }

//       // Fetch tickets and join with joinedB
//       QuerySnapshot ticketSnapshot = await _db.collection('tickets').get();
//       List<Map<String, dynamic>> tickets = ticketSnapshot.docs
//           .map((doc) =>
//               {'ticket_id': doc.id, ...doc.data() as Map<String, dynamic>})
//           .toList();

//       List<Map<String, dynamic>> finalResult = [];
//       for (var ticket in tickets) {
//         var round = joinedB.firstWhere(
//             (round) => round['round_id'] == ticket['round_id'],
//             orElse: () => {});
//         if (round.isNotEmpty) {
//           finalResult.add({
//             ...ticket,
//             'round': round,
//           });
//         }
//       }

//       // Print or use the finalResult as needed
//       for (var item in finalResult) {
//         print(item);
//       }
//       // return finalResult;
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
// }


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List> fetchJoinedData() async {
    try {
      // Fetch cinemas
      QuerySnapshot cinemaSnapshot = await _db.collection('cinemas').get();
      List<Map<String, dynamic>> cinemas = cinemaSnapshot.docs
          .map((doc) =>
              {'cinema_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // Fetch rooms and join with cinemas
      QuerySnapshot roomSnapshot = await _db.collection('rooms').get();
      List<Map<String, dynamic>> rooms = roomSnapshot.docs
          .map((doc) =>
              {'room_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      List<Map<String, dynamic>> joinedA = [];
      for (var room in rooms) {
        var cinema = cinemas.firstWhere(
            (cinema) => cinema['cinema_id'] == room['cinema_id'],
            orElse: () => {});
        if (cinema.isNotEmpty) {
          joinedA.add({
            ...room,
            'cinema': cinema,
          });
        }
      }

      // Fetch rounds and join with joinedA
      QuerySnapshot roundSnapshot = await _db.collection('rounds').get();
      List<Map<String, dynamic>> rounds = roundSnapshot.docs
          .map((doc) =>
              {'round_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      List<Map<String, dynamic>> joinedB = [];
      for (var round in rounds) {
        var room = joinedA.firstWhere(
            (room) => room['room_id'] == round['room_id'],
            orElse: () => {});
        if (room.isNotEmpty) {
          joinedB.add({
            ...round,
            'room': room,
          });
        }
      }

      // Fetch tickets and join with joinedB
      QuerySnapshot ticketSnapshot = await _db.collection('tickets').get();
      List<Map<String, dynamic>> tickets = ticketSnapshot.docs
          .map((doc) =>
              {'ticket_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      List<Map<String, dynamic>> finalResult = [];
      for (var ticket in tickets) {
        var round = joinedB.firstWhere(
            (round) => round['round_id'] == ticket['round_id'],
            orElse: () => {});
        if (round.isNotEmpty) {
          finalResult.add({
            ...ticket,
            'round': round,
          });
        }
      }
      return finalResult;
      // Print or use the finalResult as needed
      for (var item in finalResult) {
        print(item);
      }
      // return finalResult;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
