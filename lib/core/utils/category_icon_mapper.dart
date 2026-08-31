// core/utils/category_icon_mapper.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CategoryIconMapper {
  CategoryIconMapper._();

  static IconData iconFor(String category) {
    // ກວດສອບວ່າເປັນ iOS ຫຼື macOS ຫຼືບໍ່ (ຮອງຮັບ Web ໂດຍບໍ່ error)
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS || 
                  defaultTargetPlatform == TargetPlatform.macOS;

    switch (category) {
      case 'Food':
        // ໝາຍເຫດ: Cupertino ບໍ່ມີໄອຄອນຮ້ານອາຫານໂດຍກົງ, ສາມາດໃຊ້ Material ແທນໄດ້
        return isIOS ? Icons.restaurant_outlined : Icons.restaurant_outlined;
      case 'Travel':
        return isIOS ? CupertinoIcons.airplane : Icons.flight_outlined;
      case 'Sports':
        return isIOS ? CupertinoIcons.sportscourt : Icons.sports_soccer_outlined;
      case 'Medical':
        return isIOS ? CupertinoIcons.bandage : Icons.medical_services_outlined;
      case 'Entertainment':
        return isIOS ? CupertinoIcons.film : Icons.movie_outlined;
      case 'Shopping':
        return isIOS ? CupertinoIcons.shopping_cart : Icons.shopping_bag_outlined;
      case 'Electric/Water bills':
        return isIOS ? CupertinoIcons.bolt : Icons.bolt_outlined;
      case 'Salary':
        return isIOS ? CupertinoIcons.money_dollar : Icons.work_outline;
      case 'Business':
        return isIOS ? CupertinoIcons.briefcase : Icons.business_center_outlined;
      case 'Bonus':
        return isIOS ? CupertinoIcons.gift : Icons.card_giftcard_outlined;
      default:
        return isIOS ? CupertinoIcons.doc_text : Icons.receipt_long_outlined;
    }
  }
}