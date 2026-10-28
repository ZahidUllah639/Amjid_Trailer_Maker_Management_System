part of 'erp_cubit.dart';

class ERPState extends Equatable {
  final Map<String, Account> accounts;
  final List<Supplier> suppliers;
  final List<Labour> labours;
  final List<Traila> trailas;
  final List<Buyer> buyers;
  final List<Sale> sales;
  final List<Invoice> invoiceList;
  final List<Product> products;
  final List<Khata> khatas;
  final String? currentTrailaHistoryId;
  final bool isLoading;
  final int currentModuleIndex;
  final String ownerName;
  final String ownerWhatsapp;
  final String ownerPhone;
  final String ownerAddress;
  final AppProfile? appProfile;
  final PrinterSetting printerSetting;
  final String searchQuery;

  const ERPState({
    this.accounts = const {},
    this.suppliers = const [],
    this.labours = const [],
    this.trailas = const [],
    this.buyers = const [],
    this.sales = const [],
    this.invoiceList = const [],
    this.products = const [],
    this.khatas = const [],
    this.currentTrailaHistoryId,
    this.isLoading = false,
    this.currentModuleIndex = 0,
    this.ownerName = 'Manager',
    this.ownerWhatsapp = '',
    this.ownerPhone = '',
    this.ownerAddress = '',
    this.appProfile,
    this.printerSetting = const PrinterSetting(),
    this.searchQuery = '',
  });

  factory ERPState.initial() {
    return ERPState(
      accounts: const {},
    );
  }

  ERPState copyWith({
    Map<String, Account>? accounts,
    List<Supplier>? suppliers,
    List<Labour>? labours,
    List<Traila>? trailas,
    List<Buyer>? buyers,
    List<Sale>? sales,
    List<Invoice>? invoiceList,
    List<Product>? products,
    List<Khata>? khatas,
    String? Function()? currentTrailaHistoryId,
    bool? isLoading,
    int? currentModuleIndex,
    String? ownerName,
    String? ownerWhatsapp,
    String? ownerPhone,
    String? ownerAddress,
    AppProfile? Function()? appProfile,
    PrinterSetting? printerSetting,
    String? searchQuery,
  }) {
    return ERPState(
      accounts: accounts ?? this.accounts,
      suppliers: suppliers ?? this.suppliers,
      labours: labours ?? this.labours,
      trailas: trailas ?? this.trailas,
      buyers: buyers ?? this.buyers,
      sales: sales ?? this.sales,
      invoiceList: invoiceList ?? this.invoiceList,
      products: products ?? this.products,
      khatas: khatas ?? this.khatas,
      currentTrailaHistoryId: currentTrailaHistoryId != null ? currentTrailaHistoryId() : this.currentTrailaHistoryId,
      isLoading: isLoading ?? this.isLoading,
      currentModuleIndex: currentModuleIndex ?? this.currentModuleIndex,
      ownerName: ownerName ?? this.ownerName,
      ownerWhatsapp: ownerWhatsapp ?? this.ownerWhatsapp,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerAddress: ownerAddress ?? this.ownerAddress,
      appProfile: appProfile != null ? appProfile() : this.appProfile,
      printerSetting: printerSetting ?? this.printerSetting,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [accounts, suppliers, labours, trailas, buyers, sales, invoiceList, products, khatas, currentTrailaHistoryId, isLoading, currentModuleIndex, ownerName, ownerWhatsapp, ownerPhone, ownerAddress, appProfile, printerSetting, searchQuery];
}
