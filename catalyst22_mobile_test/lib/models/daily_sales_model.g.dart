// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySalesModelAdapter extends TypeAdapter<DailySalesModel> {
  @override
  final int typeId = 6;

  @override
  DailySalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySalesModel(
      cash: fields[57] as double,
      ar: fields[58] as double,
      gross: fields[60] as double,
      soldProducts: (fields[61] as List).cast<SalesReportModel>(),
      dateTime: fields[62] as DateTime,
      numberOfProducts: fields[63] as int,
      expenses: fields[80] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailySalesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(57)
      ..write(obj.cash)
      ..writeByte(58)
      ..write(obj.ar)
      ..writeByte(60)
      ..write(obj.gross)
      ..writeByte(61)
      ..write(obj.soldProducts)
      ..writeByte(62)
      ..write(obj.dateTime)
      ..writeByte(63)
      ..write(obj.numberOfProducts)
      ..writeByte(80)
      ..write(obj.expenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
