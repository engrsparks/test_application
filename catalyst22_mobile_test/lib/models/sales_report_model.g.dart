// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesReportModelAdapter extends TypeAdapter<SalesReportModel> {
  @override
  final int typeId = 4;

  @override
  SalesReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesReportModel(
      index: fields[35] as int,
      customerName: fields[36] as String,
      cash: fields[37] as double,
      discount: fields[40] as double,
      gross: fields[41] as double,
      soldProducts: (fields[42] as List).cast<CheckOutModel>(),
      dateTime: fields[43] as DateTime,
      numberOfProducts: fields[44] as int,
      cashOut: fields[45] as double,
      cashIn: fields[46] as double,
      id: fields[121] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesReportModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(35)
      ..write(obj.index)
      ..writeByte(36)
      ..write(obj.customerName)
      ..writeByte(37)
      ..write(obj.cash)
      ..writeByte(40)
      ..write(obj.discount)
      ..writeByte(41)
      ..write(obj.gross)
      ..writeByte(42)
      ..write(obj.soldProducts)
      ..writeByte(43)
      ..write(obj.dateTime)
      ..writeByte(44)
      ..write(obj.numberOfProducts)
      ..writeByte(45)
      ..write(obj.cashOut)
      ..writeByte(46)
      ..write(obj.cashIn)
      ..writeByte(121)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
