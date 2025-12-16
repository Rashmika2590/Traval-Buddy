// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DestinationAdapter extends TypeAdapter<Destination> {
  @override
  final int typeId = 0;

  @override
  Destination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Destination(
      id: fields[0] as String,
      placeName: fields[1] as String,
      country: fields[2] as String,
      notes: fields[3] as String,
      isVisited: fields[4] as bool,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Destination obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.placeName)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.isVisited)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
