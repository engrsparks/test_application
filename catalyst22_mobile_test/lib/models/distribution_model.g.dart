// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distribution_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DistributionModelAdapter extends TypeAdapter<DistributionModel> {
  @override
  final int typeId = 0;

  @override
  DistributionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DistributionModel(
      index: fields[1] as String,
      name: fields[2] as String,
      cost: fields[3] as double,
      price: fields[4] as double,
      quantity: fields[5] as int,
      dateTime: fields[6] as DateTime,
      isClicked: fields[7] as bool,
      id: fields[122] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DistributionModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.dateTime)
      ..writeByte(7)
      ..write(obj.isClicked)
      ..writeByte(122)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistributionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
