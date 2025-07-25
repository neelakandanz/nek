// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;

import 'models/shopping_item.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 2626658086718923198),
      name: 'ShoppingItem',
      lastPropertyId: const obx_int.IdUid(3, 506174155691536220),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 470730234551942644),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3290773102929455628),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 506174155691536220),
            name: 'quantity',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
obx.Store openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) {
  return obx.Store(getObjectBoxModel(),
      directory: directory,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(1, 2626658086718923198),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    ShoppingItem: obx_int.EntityDefinition<ShoppingItem>(
        model: _entities[0],
        toOneRelations: (ShoppingItem object) => [],
        toManyRelations: (ShoppingItem object) => {},
        getId: (ShoppingItem object) => object.id,
        setId: (ShoppingItem object, int id) {
          object.id = id;
        },
        objectToFB: (ShoppingItem object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final quantityOffset = fbb.writeString(object.quantity);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, quantityOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final quantityParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final object = ShoppingItem(
              id: idParam, name: nameParam, quantity: quantityParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [ShoppingItem] entity fields to define ObjectBox queries.
class ShoppingItem_ {
  /// See [ShoppingItem.id].
  static final id =
      obx.QueryIntegerProperty<ShoppingItem>(_entities[0].properties[0]);

  /// See [ShoppingItem.name].
  static final name =
      obx.QueryStringProperty<ShoppingItem>(_entities[0].properties[1]);

  /// See [ShoppingItem.quantity].
  static final quantity =
      obx.QueryStringProperty<ShoppingItem>(_entities[0].properties[2]);
}
