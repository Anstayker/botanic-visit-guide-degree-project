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
  final catalogVersion = 1;

  final rawJson = await rootBundle.loadString('assets/data/plants.json');
  final List<dynamic> plants = jsonDecode(rawJson) as List<dynamic>;
  final plantCollection = firestore.collection('plants');
  final existingSnapshot = await plantCollection.get();
  final existingIds = existingSnapshot.docs.map((doc) => doc.id).toSet();
  final seedIds = <String>{};

  for (final item in plants) {
    final map = Map<String, dynamic>.from(item as Map);
    final id = map['id']?.toString();

    if (id == null || id.isEmpty) {
      continue;
    }

    seedIds.add(id);

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
      'updated_at': FieldValue.serverTimestamp(),
    };

    await plantCollection.doc(id).set(payload, SetOptions(merge: true));
  }

  for (final obsoleteId in existingIds.difference(seedIds)) {
    await plantCollection.doc(obsoleteId).delete();
  }

  await firestore.collection('metadata').doc('plants_catalog').set({
    'version': catalogVersion,
    'plant_count': seedIds.length,
    'updated_at': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
