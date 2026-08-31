// features/expense/data/services/receipt_scanner_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ScannedReceiptData {
  final double? amount;
  final String? category;
  final String? description;
  final bool? isIncome;

  const ScannedReceiptData({
    this.amount,
    this.category,
    this.description,
    this.isIncome,
  });
}

class ReceiptScannerService {
  static final _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<ScannedReceiptData?> scan(
    File imageFile,
    List<String> expenseTypes,
    List<String> incomeTypes,
  ) async {
    if (_apiKey.isEmpty) {
      debugPrint('AI Scan Error: GEMINI_API_KEY isn\'t set');
      return null;
    }
    try {
      final model = GenerativeModel(
        model: 'gemini-3.6-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json', // ບັງຄັບໃຫ້ຕອບເປັນ JSON
        ),
      );

      final imageBytes = await imageFile.readAsBytes();
      final mimeType = _detectMimeType(imageFile.path);
      final prompt =
          '''
      You are an expert accountant parsing receipts. 
      Analyze the attached image and extract the following information.
      Return ONLY a JSON object with no additional text or markdown formatting.
      
      Rules:
      - "amount": The total final amount as a number (double).
      - "isIncome": Boolean. True if this is a receipt for receiving money, False if it's a payment/expense bill.
      - "category": If isIncome is true, match from: ${incomeTypes.join(", ")}.
                If isIncome is false, match from: ${expenseTypes.join(", ")}.
                If unsure, use "Other".
      - "description": A short, concise summary of the transaction (e.g., "KFC Lunch", "Electricity Bill").
      
      JSON format expected:
      {
        "amount": 150000,
        "isIncome": false,
        "category": "Food",
        "description": "KFC Lunch"
      }
      ''';

      final content = [
        Content.multi([TextPart(prompt), DataPart(mimeType, imageBytes)]),
      ];

      final response = await model.generateContent(content);
      final jsonText = response.text;

      if (jsonText != null) {
        final Map<String, dynamic> data = jsonDecode(jsonText);
        return ScannedReceiptData(
          amount: (data['amount'] as num?)?.toDouble(),
          isIncome: data['isIncome'] as bool?,
          category: data['category'] as String?,
          description: data['description'] as String?,
        );
      }
    } catch (e) {
      debugPrint('AI Scan Error: $e');
    }
    return null;
  }

  String _detectMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }
}
