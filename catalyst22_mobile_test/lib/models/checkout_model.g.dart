// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckOutModelAdapter extends TypeAdapter<CheckOutModel> {
  @override
  final int typeId = 2;

  @override
  CheckOutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckOutModel(
      name: fields[13] as String,
      cost: fields[14] as double,
      price: fields[15] as double,
      quantity: fields[16] as int,
      discount: fields[17] as double,
      initialQuantity: fields[18] as int,
      index: fields[19] as String,
      minimumQuantity: fields[86] as int,
      id: fields[120] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CheckOutModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(13)
      ..write(obj.name)
      ..writeByte(14)
      ..write(obj.cost)
      ..writeByte(15)
      ..write(obj.price)
      ..writeByte(16)
      ..write(obj.quantity)
      ..writeByte(17)
      ..write(obj.discount)
      ..writeByte(18)
      ..write(obj.initialQuantity)
      ..writeByte(19)
      ..write(obj.index)
      ..writeByte(86)
      ..write(obj.minimumQuantity)
      ..writeByte(120)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckOutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
