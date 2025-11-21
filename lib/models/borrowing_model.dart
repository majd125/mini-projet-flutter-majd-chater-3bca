import 'package:cloud_firestore/cloud_firestore.dart';

class Borrowing {
  String id;
  String userId;
  String mediaId;
  String mediaTitle;
  DateTime borrowDate;
  DateTime dueDate;
  DateTime? returnDate;
  String status; // 'active', 'returned', 'overdue'

  Borrowing({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaTitle,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  factory Borrowing.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Borrowing(
      id: doc.id,
      userId: data['userId'] ?? '',
      mediaId: data['mediaId'] ?? '',
      mediaTitle: data['mediaTitle'] ?? '',
      borrowDate: data['borrowDate']?.toDate() ?? DateTime.now(),
      dueDate: data['dueDate']?.toDate() ?? DateTime.now(),
      returnDate: data['returnDate']?.toDate(),
      status: data['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
    };
  }

  bool get isOverdue => dueDate.isBefore(DateTime.now()) && status == 'active';
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
}
