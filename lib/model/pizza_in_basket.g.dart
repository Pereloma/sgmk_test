// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza_in_basket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PizzaInBasketAdapter extends TypeAdapter<PizzaInBasket> {
  @override
  final int typeId = 2;

  @override
  PizzaInBasket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PizzaInBasket(
      pizza: fields[1] as Pizza,
      number: fields[2] as int?,
    ).._key = fields[0] as dynamic;
  }

  @override
  void write(BinaryWriter writer, PizzaInBasket obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._key)
      ..writeByte(1)
      ..write(obj.pizza)
      ..writeByte(2)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PizzaInBasketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
