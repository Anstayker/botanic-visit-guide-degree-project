import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:botanic_guide/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  final rawJson = await rootBundle.loadString('assets/data/plants.json');
  final List<dynamic> plants = jsonDecode(rawJson) as List<dynamic>;

  var writes = 0;

  for (final item in plants) {
    final map = Map<String, dynamic>.from(item as Map);
    final id = map['id']?.toString();

    if (id == null || id.isEmpty) {
      continue;
    }

    final payload = <String, dynamic>{
      'id': id,
      'name': map['name'],
      'scientific_name': map['scientific_name'],
      'ilumination': map['ilumination'],
      'watering': map['watering'],
      'height': map['height'],
      'growth_time': map['growth_time'],
      'min_temperature': map['min_temperature'],
      'max_temperature': map['max_temperature'],
      'image': map['image'],
      'description': map['description'],
      'category_id': map['category_id'],
      'short_description': map['short_description'],
      'latitude': map['latitude'],
      'longitude': map['longitude'],
      // Seed baseline. Increment manually when publishing data changes.
      'version': (map['version'] is num) ? (map['version'] as num).toInt() : 1,
      'updated_at': FieldValue.serverTimestamp(),
      'is_active': true,
    };

    await firestore
        .collection('plants')
        .doc(id)
        .set(payload, SetOptions(merge: true));
    writes++;
  }

  debugPrint('Firestore seeding completed. Documents upserted: $writes');
  debugPrint('Collection: plants');
  debugPrint('Project: ${Firebase.app().options.projectId}');
}
