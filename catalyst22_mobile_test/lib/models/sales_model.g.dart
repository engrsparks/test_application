// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesModelAdapter extends TypeAdapter<SalesModel> {
  @override
  final int typeId = 3;

  @override
  SalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesModel(
      index: fields[20] as int,
      customerName: fields[21] as String,
      cash: fields[22] as double,
      discount: fields[25] as double,
      gross: fields[26] as double,
      soldProducts: (fields[27] as List).cast<CheckOutModel>(),
      dateTime: fields[28] as DateTime,
      numberOfProducts: fields[29] as int,
      isSelected: fields[32] as bool,
      deliveryCharge: fields[33] as double,
      address: fields[34] as String,
      id: fields[120] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(20)
      ..write(obj.index)
      ..writeByte(21)
      ..write(obj.customerName)
      ..writeByte(22)
      ..write(obj.cash)
      ..writeByte(25)
      ..write(obj.discount)
      ..writeByte(26)
      ..write(obj.gross)
      ..writeByte(27)
      ..write(obj.soldProducts)
      ..writeByte(28)
      ..write(obj.dateTime)
      ..writeByte(29)
      ..write(obj.numberOfProducts)
      ..writeByte(32)
      ..write(obj.isSelected)
      ..writeByte(33)
      ..write(obj.deliveryCharge)
      ..writeByte(34)
      ..write(obj.address)
      ..writeByte(120)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
