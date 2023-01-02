// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlySalesModelAdapter extends TypeAdapter<MonthlySalesModel> {
  @override
  final int typeId = 8;

  @override
  MonthlySalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlySalesModel(
      cash: fields[66] as double,
      ar: fields[68] as double,
      netSales: fields[69] as double,
      grossProfit: fields[70] as double,
      dateTime: fields[71] as DateTime,
      numberOfProductsSold: fields[72] as int,
      expenses: fields[81] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlySalesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(66)
      ..write(obj.cash)
      ..writeByte(68)
      ..write(obj.ar)
      ..writeByte(69)
      ..write(obj.netSales)
      ..writeByte(70)
      ..write(obj.grossProfit)
      ..writeByte(71)
      ..write(obj.dateTime)
      ..writeByte(72)
      ..write(obj.numberOfProductsSold)
      ..writeByte(81)
      ..write(obj.expenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlySalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
