// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PizzaAdapter extends TypeAdapter<Pizza> {
  @override
  final int typeId = 1;

  @override
  Pizza read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pizza(
      name: fields[1] as String,
      price: fields[2] as int,
      balance: fields[3] as int,
      asset: fields[4] as String?,
    ).._key = fields[0] as dynamic;
  }

  @override
  void write(BinaryWriter writer, Pizza obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.asset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PizzaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
