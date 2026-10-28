import 'package:equatable/equatable.dart';

class PrinterSetting extends Equatable {
  final String deviceName;
  final String deviceAddress;
  final String? vendorId;
  final String? productId;
  final String paperSize; // '58mm' or '80mm'
  final String connectionType; // 'USB' or 'Bluetooth'
  final bool autoCut;
  final bool autoPrint;

  const PrinterSetting({
    this.deviceName = '',
    this.deviceAddress = '',
    this.vendorId,
    this.productId,
    this.paperSize = '58mm',
    this.connectionType = 'USB',
    this.autoCut = true,
    this.autoPrint = true,
  });

  PrinterSetting copyWith({
    String? deviceName,
    String? deviceAddress,
    String? vendorId,
    String? productId,
    String? paperSize,
    String? connectionType,
    bool? autoCut,
    bool? autoPrint,
  }) {
    return PrinterSetting(
      deviceName: deviceName ?? this.deviceName,
      deviceAddress: deviceAddress ?? this.deviceAddress,
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      paperSize: paperSize ?? this.paperSize,
      connectionType: connectionType ?? this.connectionType,
      autoCut: autoCut ?? this.autoCut,
      autoPrint: autoPrint ?? this.autoPrint,
    );
  }

  @override
  List<Object?> get props => [deviceName, deviceAddress, vendorId, productId, paperSize, connectionType, autoCut, autoPrint];
}
