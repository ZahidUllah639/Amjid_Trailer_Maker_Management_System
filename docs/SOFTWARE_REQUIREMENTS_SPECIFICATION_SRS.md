# SOFTWARE REQUIREMENTS SPECIFICATION (SRS)
## Master Trailers ERP & Workshop Management System
**Document Identifier:** SRS-MTERP-2026-V1.0  
**Standard:** IEEE 830-1998 / ISO/IEC/IEEE 29148:2018  
**Client Organization:** Amjid Trailer Makers  
**Application Title:** Master Trailers ERP  
**Release Version:** 1.0.0+1 (Production Release)  
**Publication Date:** October 2026  
**Status:** Approved & Formally Baselined  

---

## EXECUTIVE SUMMARY

Master Trailers ERP is an industrial-grade, mission-critical desktop Enterprise Resource Planning (ERP) and Manufacturing Execution System (MES) engineered specifically for commercial vehicle fabrication, heavy semi-trailer assembly, and transport equipment manufacturing enterprises.

Fabrication of multi-axle semi-trailers, low-bed transporters, flatbeds, and custom cargo haulers involves complex procurement of high-tensile steel, axles, leaf springs, hydraulic cylinders, and specialized tyres. Traditional manual ledger books and generic accounting packages fail to capture:
1. Direct linkage between raw material bills and specific trailer chassis builds.
2. Piece-rate wage tracking for artisan welding and fabrication teams.
3. Multi-counterparty Khata credit ledgers with running balance audits.
4. Profitability per trailer unit calculated against fluctuating bill of materials (BOM).
5. Offline-first resilience in demanding industrial workshop environments without continuous internet connectivity.

Master Trailers ERP solves these challenges through a unified Flutter Windows Desktop architecture powered by a high-performance C++ SQLite FFI engine (via Drift), reactive BLoC/Cubit state management, dual ESC/POS thermal (58mm/80mm) and A4 laser printing pipelines, and an automated zero-loss disaster recovery snapshot system.

---

## 1. INTRODUCTION

### 1.1 Purpose
This document provides a comprehensive, forensic specification of all functional and non-functional requirements for the Master Trailers ERP software. It serves as the authoritative technical and operational contract between Amjid Trailer Makers (Executive Management and Workshop Operations) and the Engineering Architecture Team.

### 1.2 Scope of the System
The software encompasses ten interconnected functional subsystems:
1. **Executive Operations Dashboard**: High-level liquidity, inventory status, and operational intelligence.
2. **Traila Fleet Register & Costing Engine**: Vehicle chassis serialization, status lifecycle, and real-time BOM cost accumulation.
3. **Supplier Procurement & Material Ledger**: Vendor profiling, multi-item line procurement, upfront payment routing, and running debt ledgers.
4. **Labour & Piece-Rate Wages System**: Artisan workforce rosters, piece-rate fabrication task logging, wage payouts, and running balance ledgers.
5. **Multi-Entity Khata Ledger Engine**: Customer, contractor, and partner credit/debit accounts with optional liquid account synchronization.
6. **Commercial Sales & Invoicing Subsystem**: Finished goods inventory allocation, customer debt tracking, gross profit calculation, downpayments, and installment tracking.
7. **Cash & Bank Liquidity Management (Treasury)**: Multi-account liquidity tracking, double-entry ledger transactions, and inter-account funds transfers.
8. **Operating Overheads & Scrap Revenue Engine**: Workshop operational expenses, utility costs, and scrap/auxiliary income auditing.
9. **Dual Hardware Printing Engine**: ESC/POS thermal printing (58mm / 80mm) with two-pass high-contrast bitmap dithering and vector A4 PDF stationery.
10. **Disaster Recovery & Backup Subsystem**: User-selected automated timestamped SQLite database backups and seamless hot-reload restoration.

### 1.3 Definitions, Acronyms, and Abbreviations
- **ACID**: Atomicity, Consistency, Isolation, Durability (database transaction properties).
- **BLoC**: Business Logic Component (state management architecture).
- **BOM**: Bill of Materials (total raw materials and components required to build a unit).
- **CNIC**: Computerized National Identity Card (official government identification).
- **Drift**: Type-safe persistence library for Dart & Flutter wrapping SQLite.
- **ESC/POS**: Standardized printer control language for point-of-sale thermal receipt printers.
- **FFI**: Foreign Function Interface (native C-interop mechanism in Dart).
- **Khata**: Traditional informal ledger system tracking credits ("Got" / In) and debits ("Gave" / Out).
- **MES**: Manufacturing Execution System.
- **POS**: Point of Sale.
- **SRS**: Software Requirements Specification.
- **Traila**: Regional terminology for heavy commercial semi-trailer chassis.
- **WIP**: Work in Progress (units currently undergoing fabrication in the workshop).

### 1.4 References
- IEEE Std 830-1998: IEEE Recommended Practice for Software Requirements Specifications.
- ISO/IEC/IEEE 29148:2018: Systems and software engineering — Life cycle processes — Requirements engineering.
- SQLite Database Architecture & ACID Guarantees Specification.
- Epson ESC/POS Command Reference Standard.

---

## 2. OVERALL SYSTEM ARCHITECTURE & ENVIRONMENT

### 2.1 Product Perspective & Context
Master Trailers ERP operates as a standalone, ultra-reliable desktop application running natively on the Microsoft Windows operating system (Windows 10 / Windows 11, x64).

```
+-----------------------------------------------------------------------+
|                    MASTER TRAILERS ERP APPLICATION                   |
+-----------------------------------------------------------------------+
|  Presentation Layer: Custom Glassmorphic Frameless Window Chrome      |
|  (Responsive Header, DragToMoveArea, Win11 Controls, Modern Modals)   |
+-----------------------------------------------------------------------+
|  State Management & Business Logic Layer: ERPCubit & ERPState (BLoC)  |
|  - Real-time Balance Computations  - Dual-entry Transaction Routing   |
|  - Traila Build BOM Accumulation   - Opening Balance Integrity Healing|
+-----------------------------------------------------------------------+
|  Hardware & Output Services Layer:                                    |
|  - UnifiedPrintService (Vector A4 PDF Engine)                         |
|  - ThermalPrinterService (ESC/POS 58mm/80mm Dithered Raster Engine)   |
|  - BackupService (Timestamped Snapshot Compression)                   |
|  - WhatsAppService (URI Scheme Integration)                           |
+-----------------------------------------------------------------------+
|  Persistence Layer: Drift ORM over sqlite3_flutter_libs (FFI)         |
|  - 19 Normalized Relational Tables with Foreign Key Constraints       |
|  - Native Local Storage (traila.sqlite)                               |
+-----------------------------------------------------------------------+
```

### 2.2 Operating Environment
- **Operating System:** Microsoft Windows 10 (Build 19041+) or Windows 11 (64-bit).
- **Minimum Hardware:** Dual-Core x64 CPU @ 2.0 GHz, 4 GB RAM, 500 MB free storage.
- **Recommended Hardware:** Quad-Core Intel Core i5 / AMD Ryzen 5, 8 GB RAM, Fast SSD.
- **Thermal Printing Hardware:** 58mm (2-inch, 384 dots/line) or 80mm (3-inch, 576 dots/line) ESC/POS USB or Bluetooth receipt printers.
- **Office Printing Hardware:** Any standard Windows-compatible A4 Laser/Inkjet printer.
- **Display Resolution:** Optimized for 1366x768 (HD), 1920x1080 (Full HD), and 4K displays with responsive search constraints and dynamic layout scaling.

---

## 3. DETAILED FUNCTIONAL REQUIREMENTS

### 3.1 Module 1: Operations Dashboard & Executive Intelligence
The Operations Dashboard serves as the command center for workshop executives, providing real-time operational and financial visibility.

#### Functional Specifications:
- **FR-DSH-001 (Aggregated Net Worth & Liquidity KPI):** The system shall compute the cumulative balance across all active liquid accounts (Cash, Bank Accounts, Wallets) in real time:
  $$\text{Total Liquidity} = \sum_{i=1}^{n} \text{AccountBalance}_i$$
- **FR-DSH-002 (Monthly Financial Velocity KPIs):**
  - **Monthly Inflow (Credits):** Sum of all transaction credits across all accounts recorded during the active calendar month.
  - **Monthly Outflow (Debits):** Sum of all transaction debits across all accounts recorded during the active calendar month.
- **FR-DSH-003 (Production Lot Inventory KPI):** The system shall calculate the count and total manufacturing valuation of all completed units currently parked in the yard with `TrailaStatus.ready`.
- **FR-DSH-004 (Receivables & Payables Summary):**
  - **Client Receivables:** Aggregate outstanding debt owed by buyers on active vehicle sales plus positive Khata customer balances.
  - **Supplier Payables:** Aggregate outstanding dues owed to raw material vendors.
  - **Workforce Payables:** Aggregate net wages payable across all registered artisans.
- **FR-DSH-005 (Quick Action Speed Dial):** One-click modal launchers for:
  - Registering a new Traila Chassis unit.
  - Recording a Supplier Purchase Bill.
  - Recording an Artisan Labour Work Entry.
  - Recording a Customer Khata Transaction.
  - Initiating an Instant Database Backup Snapshot.
- **FR-DSH-006 (Recent Activity Feed):** Chronological stream displaying the 10 most recent ledger events across all modules with color-coded badges and timestamping.

---

### 3.2 Module 2: Traila Fleet Register & Cost Accumulation (MES)
This module governs the core manufacturing lifecycle of commercial semi-trailer units.

#### Functional Specifications:
- **FR-TRL-001 (Chassis Registration):** The user shall register a new vehicle with:
  - Unique Unit Identifier (`id`, e.g., `TR-2026-001`, custom alphanumeric).
  - Descriptive Model Name (`name`, e.g., "40ft 3-Axle Flatbed Heavy Hauler").
  - Registration/Commencement Date (`registrationDate`).
  - Initial Status (`status = TrailaStatus.pending`).
- **FR-TRL-002 (Lifecycle State Machine):**
  - `pending`: Unit is actively under construction in the fabrication bay.
  - `ready`: Fabrication, painting, wiring, and QA completed; unit moved to finished goods lot.
  - `sold`: Commercial invoice generated; unit dispatched to client.
- **FR-TRL-003 (Automated Bill of Materials Cost Accumulation):**
  The total manufacturing cost of any vehicle ($C_{\text{Total}}$) is dynamically calculated:
  $$C_{\text{Total}} = \sum C_{\text{Materials}} + \sum C_{\text{Labour}} + \sum C_{\text{Additional}}$$
  - $C_{\text{Materials}}$: Automatically pulled from supplier purchase bills linked to this Traila ID.
  - $C_{\text{Labour}}$: Automatically pulled from workforce work entries linked to this Traila ID.
  - $C_{\text{Additional}}$: Manual shop floor overheads (e.g., priming paint, consumables, crane rental).
- **FR-TRL-004 (Lined Cost Breakdown & Expense Detail Modal):**
  - The vehicle history screen (`TrailaHistoryScreen`) shall display all incurred costs in a compact, lined list separated by 1px dividers.
  - Clicking any expense row shall open `_ExpenseDetailModal` equipped with:
    * Modal Titlebar Window Controls (`–` minimize/dismiss, `🗖`/`🗗` maximize/restore, `✕` close).
    * Prominent Expense Amount Header.
    * 2x2 Specification Matrix (Traila Unit, Cost Category, Date Incurred, Ledger Linkage).
    * Description container with copy-to-clipboard functionality.
    * Edit and Delete actions that automatically update the parent Traila manufacturing cost in the database.

---

### 3.3 Module 3: Supplier Management & Procurement Ledger
This module manages all vendor interactions, procurement of steel, axles, springs, and tires, and the associated accounts payable.

#### Functional Specifications:
- **FR-SUP-001 (Vendor Profile Capture):** Registration of suppliers with Manual ID, Full Name, Contact Number, WhatsApp Number, Shop/Firm Name, Geolocation/Market Location, Physical Address, and Initial Opening Balance.
- **FR-SUP-002 (Multi-Item Purchase Bill Entry):**
  - Bill Number (`billNumber`, e.g., `INV-SUP-9842`).
  - Optional Target Traila Unit Selection (`trailaId`).
  - Purchase Item Grid: Dynamic rows with Item Name, Quantity, Unit Price, and auto-computed Line Total:
    $$\text{LineTotal}_k = \text{Quantity}_k \times \text{UnitPrice}_k$$
  - Bill Total: $\text{BillTotal} = \sum \text{LineTotal}_k$.
- **FR-SUP-003 (Three-Stage Financial Audit Reconciliation):**
  When a purchase bill is committed with an optional upfront payment ($P_{\text{Upfront}}$):
  1. $\text{Balance Before} = \text{Supplier}.\text{remainingBalance}$
  2. $\text{Bill Amount} = \text{BillTotal}$
  3. $\text{Upfront Payment} = P_{\text{Upfront}}$ (deducted from selected Cash/Bank account)
  4. $\text{Net Balance After} = \text{Balance Before} + \text{Bill Amount} - P_{\text{Upfront}}$
- **FR-SUP-004 (Stand-Alone Payment Voucher):**
  - Ability to disburse subsequent payments to suppliers.
  - Selection of payment account (Cash, Bank Account, Online Wallet).
  - Support for split payment breakdown (`SplitDetails`) across multiple instruments.
  - Sequential Receipt Number generation (`REC-SP-xxxx`).
- **FR-SUP-005 (Lined Ledger Rows & Supplier Detail Modal):**
  - In `SupplierProfileScreen`, transactions shall render as compact lined rows (`SupplierLedgerRow`).
  - Clicking a row shall trigger `SupplierRecordDetailModal`, displaying:
    * Dedicated window controls in the modal header.
    * 3-Stage financial flow banner.
    * Complete itemized breakdown table of procured materials.
    * Upfront payment method and audit stamps.
    * Instant A4 PDF Bill and 58mm/80mm Thermal Receipt printing buttons.
- **FR-SUP-006 (WhatsApp Procurement Voucher):** Direct sharing of formatted purchase receipts to the supplier's WhatsApp number with pre-composed bill details and balance summaries.

---

### 3.4 Module 4: Labour & Workforce Wages Management
This module tracks piece-rate fabrication contracts, skilled trades (welders, assemblers, painters), and payroll disbursals.

#### Functional Specifications:
- **FR-LBR-001 (Artisan Profile):** Manual Worker ID, Full Name, Contact Phone, WhatsApp Number, Residential Address, Registration Date, and Opening Wage Balance.
- **FR-LBR-002 (Piece-Rate Work Logging):**
  - Task Entry Code (`entryNumber`, e.g., `INV-LW-0002`).
  - Associated Traila Chassis (`trailaId`).
  - Detailed Scope of Work (`description`, e.g., "Main I-Beam Chassis Assembly, Double Welding & Suspension Bracket Mounting").
  - Agreed Piece-Rate Wage (`cost`).
  - Date of completion.
  - Auto-increments both the worker's net payable balance and the target Traila unit's manufacturing cost.
- **FR-LBR-003 (Wage Disbursement Voucher):**
  - Disbursal of partial or complete wages.
  - Deducts funds from the chosen workshop liquid account and credits the workforce ledger.
  - Sequential wage receipt generation.
- **FR-LBR-004 (Lined Ledger & Labour Detail Modal):**
  - Renders as high-density lined items separated by 1px dividers.
  - Clicking any work or wage entry launches `_LabourRecordDetailModal` featuring:
    * Modal window controls (Minimize, Maximize, Close).
    * 3-Stage financial breakdown (Balance Before $\rightarrow$ Payout $\rightarrow$ Balance After).
    * Full task scope with one-click clipboard copy.
    * Thermal Receipt (58mm/80mm) and Vector A4 PDF voucher printing.

---

### 3.5 Module 5: Multi-Entity Khata Ledger Engine
The Khata subsystem handles credit/debit accounts for clients, transport contractors, partners, and outside businesses.

#### Functional Specifications:
- **FR-KHT-001 (Khata Party Creation):** Registration of entity name, registration date, and opening balance.
- **FR-KHT-002 (Got / In vs Gave / Out Dual Transaction Engine):**
  - **Got / Cash In (Credit):** Payment received from party. Reduces party debt or creates advance.
  - **Gave / Cash Out (Debit):** Cash or services provided to party. Increases party debt or consumes advance.
- **FR-KHT-003 (Running Balance Formulation):**
  $$\text{Net Balance} = \text{OpeningBalance} + \sum \text{Amount}_{\text{CashOut}} - \sum \text{Amount}_{\text{CashIn}}$$
  - If $\text{Net Balance} > 0.01$: Account categorized as **Receivable (Due)** (Party owes workshop).
  - If $\text{Net Balance} < -0.01$: Account categorized as **Advance / Payable** (Workshop owes party).
  - If $\text{Net Balance} == 0.00$: Account categorized as **Settled**.
- **FR-KHT-004 (Ledger Synchronization Toggle):**
  Each transaction features a `syncToAccount` boolean flag:
  - If `true`: The transaction credits/debits the official workshop cash/bank liquidity account.
  - If `false`: The entry remains strictly within the bilateral Khata ledger without affecting official workshop liquidity (ideal for personal or non-cash settlements).
- **FR-KHT-005 (Lined Ledger Rows & Khata Detail Modal):**
  - Compact table view with 1px dividers, directional icons (`arrow_downward` for Got, `arrow_outward` for Gave), and running balance pills.
  - Clicking launches `_KhataRecordDetailModal` with modal window controls, 3-stage audit math, specifications matrix, copyable description, and thermal receipt print actions.

---

### 3.6 Module 6: Sales, Commercial Invoicing & Receivables
This module governs the commercial sale of completed trailer units, installment plans, and client debt reconciliation.

#### Functional Specifications:
- **FR-SAL-001 (Commercial Sale Booking):**
  - Selection of a finished vehicle with `TrailaStatus.ready`.
  - Selection or instant on-the-fly registration of Buyer (Name, Phone, CNIC, Address).
  - Agreed Sale Price ($P_{\text{Sale}}$).
- **FR-SAL-002 (Real-Time Profitability Computation):**
  Upon booking, the system pulls the cumulative manufacturing cost ($C_{\text{Mfg}}$) from the vehicle history and calculates:
  $$\text{Gross Profit} = P_{\text{Sale}} - C_{\text{Mfg}}$$
  $$\text{Profit Margin } \% = \left( \frac{\text{Gross Profit}}{P_{\text{Sale}}} \right) \times 100$$
  This data is kept internal for executive auditing and omitted from client-facing receipts.
- **FR-SAL-003 (Global Client Debt Linkage):**
  If the buyer has prior unsettled balances from earlier vehicle purchases ($B_{\text{Global}}$), the system binds this debt into the new invoice:
  $$\text{Gross Customer Liability} = P_{\text{Sale}} + B_{\text{Global}}$$
- **FR-SAL-004 (Downpayment & Sequential Receipting):**
  - Receipt Number generated in official sequence (`SR-xxxxx`).
  - Downpayment credited immediately to chosen workshop liquid account.
  - Status set dynamically:
    * `SaleStatus.paid` if $\text{Paid} \ge \text{Gross Liability}$.
    * `SaleStatus.partial` if $0 < \text{Paid} < \text{Gross Liability}$.
    * `SaleStatus.pending` if $\text{Paid} == 0$.
- **FR-SAL-005 (Installment Payment Collection):**
  Subsequent installment collections decrease the remaining balance and update the buyer's global ledger.
- **FR-SAL-006 (Executive Invoice Presentation):**
  `SaleDetailScreen` provides visual progress indicators of payment completion, profit margins, PDF A4 invoice generation, POS thermal printing, and WhatsApp invoice dispatch.

---

### 3.7 Module 7: Cash Flow, Bank Treasury & Liquidity
Governs enterprise treasury, bank accounts, and multi-instrument liquidity tracking.

#### Functional Specifications:
- **FR-ACC-001 (Multi-Account Setup):** Pre-configured default accounts (`Cash in Hand`, `Meezan Bank`, `HBL`, `Allied Bank`, `EasyPaisa`, `JazzCash`) with support for custom bank accounts.
- **FR-ACC-002 (Transaction Double-Entry Accounting):**
  - **Credit (Add):** Deposits, capital investments, invoice receipts.
  - **Debit (Take):** Withdrawals, vendor disbursements, wage payouts, expense bills.
- **FR-ACC-003 (Inter-Account Internal Transfer):**
  - Instant transfer of liquidity between internal accounts (e.g., Bank Withdrawal to Cash in Hand).
  - Executes atomic dual-entry transaction with linked transfer ID:
    * Account A (Source): Debit transaction of amount $X$.
    * Account B (Destination): Credit transaction of amount $X$.
- **FR-ACC-004 (Persistent Header Liquidity Capsule):** The persistent application header dynamically re-evaluates and displays total real-time liquidity across all accounts.

---

### 3.8 Module 8: Operating Expenses & Secondary Revenue
#### Functional Specifications:
- **FR-EXP-001 (Overhead Expense Categorization):** Categorized tracking of factory rent, industrial electricity, welding gas, diesel/fuel, transport, meals, machine maintenance, and taxes.
- **FR-EXP-002 (Secondary Revenue Streams):** Logging non-trailer income such as scrap metal sales, body repair work, chassis modification, and accessory installations.
- **FR-EXP-003 (Date Range & Category Filtering):** Real-time aggregation of expenses and revenues by custom date ranges and categories for net profit determination.

---

### 3.9 Module 9: Enterprise Dual Printing Engine
#### Functional Specifications:
- **FR-PRN-001 (Hardware Support):** Native support for both 58mm (2-inch, 384 dots) and 80mm (3-inch, 576 dots) ESC/POS USB and Bluetooth thermal printers.
- **FR-PRN-002 (Two-Pass High-Contrast Rasterization):**
  - Thermal printers cannot render subtle grayscale logos without blurry artifacts.
  - The system applies a specialized two-pass Floyd-Steinberg bitmap threshold dithering algorithm to the isolated trailer truck logo, yielding crisp black-on-white output on thermal rolls.
- **FR-PRN-003 (Duplicate Customer/Merchant Printing):** Configurable automated double-receipt printing for customer handoff and merchant filing.
- **FR-PRN-004 (Vector A4 Laser Stationery):**
  - Generates publication-grade PDF documents using `package:pdf`.
  - Features Amjid Trailer Makers corporate typography, tabular matrices, carbon copy styling, and formal signature and stamp authorization zones.
- **FR-PRN-005 (In-App Print Preview Dialog):** Integrated previewer (`PrintPreviewDialog`) supporting vector zoom, page navigation, direct print submission, and PDF export.

---

### 3.10 Module 10: Automated Disaster Recovery & Backup
#### Functional Specifications:
- **FR-BAK-001 (User-Selected Storage Target):** Users can designate any local directory, external USB flash drive, or network drive as the backup target via native Windows directory picker.
- **FR-BAK-002 (Automated Timestamped Naming):** Backups are saved in structured folders reflecting the day name, date, and hour:
  $$\text{Backup\_[DayName]\_[DD-MMM-YYYY]\_[hh-mm-ss\_a]}$$
  Example: `Backup_Thursday_29-Oct-2026_08-50-30_PM`
- **FR-BAK-003 (Atomic Snapshot Creation):** Copies the complete `traila.sqlite` database and metadata into the selected directory without interrupting active operations.
- **FR-BAK-004 (Safe Restoration with Auto-Healing):**
  - Single-click restore from any past snapshot folder.
  - Closes active database handles, replaces database files, re-initializes connection pools, and runs automatic startup data healing (restoring opening balance invoices and missing sales downpayments).

---

### 3.11 Module 11: Desktop Window Management & Design System
#### Functional Specifications:
- **FR-UI-001 (Frameless Windows 11 Chrome):**
  - The main header features custom Windows 11 controls (`–` Minimize, `🗖`/`🗗` Maximize/Restore, `✕` Close with red hover).
  - Header title area wrapped in `DragToMoveArea` allowing natural OS window dragging across multi-monitor setups.
  - Search box constrained to prevent header layout overflow on sub-1080p screens.
- **FR-UI-002 (Modal Dialog Sub-Window Controls):**
  Every record detail dialog contains dedicated minimize/dismiss, maximize view toggle, and close cross buttons.
- **FR-UI-003 (Lined List Format):** Replaces oversized visual cards with compact, single-row lined list items separated by 1px dividers, displaying full record details inside executive popup modals.
- **FR-UI-004 (Cinematic Dark-Mode Startup Intro):** Fast, smooth animated entrance overlay featuring the isolated electric blue trailer truck with glowing neon speed trails.

---

## 4. DATA MODELS & RELATIONAL SCHEMA

The persistence layer is implemented in SQLite via Drift ORM, featuring 19 normalized relational tables:

```
+---------------------------------------------------------------------------------------------------+
|                                  ENTITY RELATIONSHIP OVERVIEW                                     |
+---------------------------------------------------------------------------------------------------+
|  [Suppliers] <----+ (1:N) --- [Invoices]                                                          |
|       |           |                |                                                              |
|       | (1:N)     | (1:N)          +--- (1:N) ---> [InvoiceItems]                                 |
|       v           |                                                                               |
|  [Payments] <-----+ (1:N) --- [SplitDetails]                                                      |
|       ^                                                                                           |
|       | (1:N)                                                                                     |
|  [Labours] <------+ (1:N) --- [LabourWorkEntries]                                                 |
|       |                                |                                                          |
|       | (1:N)                          | (N:1, optional)                                          |
|       +-----------> [TrailaExpenses] <-+                                                          |
|                           ^                                                                       |
|                           | (N:1)                                                                 |
|                      [Trailas] <------- (1:1) ------ [Sales] <---- (N:1) ---- [Buyers]            |
|                                                         |                                         |
|                                                         +--- (1:N) ---> [Payments]                |
|                                                                                                   |
|  [Accounts] <---- (1:N) ----- [Transactions]                                                      |
|                                                                                                   |
|  [Khatas] <------ (1:N) ----- [KhataItems]                                                        |
|                                                                                                   |
|  Standalone Tables: [AppProfiles], [AppSettings], [PrinterSettings], [Products]                    |
+---------------------------------------------------------------------------------------------------+
```

### 4.1 Schema Definitions

1. **`Suppliers`**: `id` (PK, Text), `name` (Text), `phone` (Text), `shopName` (Text), `location` (Text), `whatsappNumber` (Text), `address` (Text), `registrationDate` (DateTime), `openingBalance` (Real), `totalAmount` (Real), `totalPaid` (Real), `remainingBalance` (Real), `advanceBalance` (Real), `createdAt` (DateTime).
2. **`Labours`**: `id` (PK, Text), `name` (Text), `phone` (Text), `whatsappNumber` (Text), `address` (Text), `registrationDate` (DateTime), `openingBalance` (Real), `totalPayable` (Real), `totalPaid` (Real), `remainingBalance` (Real), `createdAt` (DateTime).
3. **`Products`**: `id` (PK, Text), `name` (Text), `defaultPrice` (Real), `unit` (Text), `createdAt` (DateTime).
4. **`Invoices`**: `id` (PK, Text), `invoiceNumber` (Text), `date` (DateTime), `type` (Text), `ownerId` (Text), `ownerName` (Text), `ownerType` (Text), `trailaId` (Text, FK $\rightarrow$ `Trailas`), `amount` (Real), `previousBalance` (Real), `remainingBalance` (Real), `paymentMethod` (Text), `ownerNameDisplay` (Text), `createdAt` (DateTime).
5. **`InvoiceItems`**: `id` (PK, AutoIncrement), `invoiceId` (Text, FK $\rightarrow$ `Invoices`), `productName` (Text), `quantity` (Real), `unitPrice` (Real), `lineTotal` (Real), `createdAt` (DateTime).
6. **`Payments`**: `id` (PK, Text), `amount` (Real), `date` (DateTime), `method` (Text), `receiptNumber` (Text), `previousBalance` (Real), `updatedBalance` (Real), `ownerId` (Text), `ownerType` (Text), `createdAt` (DateTime).
7. **`SplitDetails`**: `id` (PK, AutoIncrement), `paymentId` (Text, FK $\rightarrow$ `Payments`), `method` (Text), `amount` (Real), `createdAt` (DateTime).
8. **`Transactions`**: `id` (PK, Text), `accountName` (Text), `type` (Text: add, take), `amount` (Real), `person` (Text), `description` (Text), `date` (DateTime), `category` (Text), `linkedTransferId` (Text), `createdAt` (DateTime).
9. **`LabourWorkEntries`**: `id` (PK, Text), `labourId` (Text, FK $\rightarrow$ `Labours`), `trailaId` (Text, FK $\rightarrow$ `Trailas`), `entryNumber` (Text), `description` (Text), `cost` (Real), `date` (DateTime), `previousOutstanding` (Real), `createdAt` (DateTime).
10. **`Trailas`**: `id` (PK, Text), `name` (Text), `registrationDate` (DateTime), `status` (Text: pending, ready, sold), `totalManufacturingCost` (Real), `salePrice` (Real), `createdAt` (DateTime).
11. **`TrailaExpenses`**: `id` (PK, Text), `trailaId` (Text, FK $\rightarrow$ `Trailas`), `type` (Text), `description` (Text), `amount` (Real), `date` (DateTime), `supplierId` (Text, FK $\rightarrow$ `Suppliers`), `labourId` (Text, FK $\rightarrow$ `Labours`), `createdAt` (DateTime).
12. **`Buyers`**: `id` (PK, Text), `name` (Text), `phone` (Text), `cnic` (Text), `address` (Text), `whatsappNumber` (Text), `createdAt` (DateTime).
13. **`Sales`**: `id` (PK, Text), `trailaId` (Text, FK $\rightarrow$ `Trailas`), `buyerId` (Text, FK $\rightarrow$ `Buyers`), `salePrice` (Real), `manufacturingCost` (Real), `profit` (Real), `saleDate` (DateTime), `paidAmount` (Real), `remainingBalance` (Real), `receiptNumber` (Text), `globalPreviousBalance` (Real), `createdAt` (DateTime).
14. **`AppSettings`**: `key` (PK, Text), `value` (Text).
15. **`AppProfiles`**: `id` (PK, Text), `businessName` (Text), `ownerName` (Text), `phoneNumber` (Text), `address` (Text), `businessType` (Text), `whatsappNumber` (Text).
16. **`Accounts`**: `id` (PK, Text), `name` (Text), `balance` (Real), `type` (Text: cash, bank, wallet, other), `iconType` (Text), `createdAt` (DateTime).
17. **`PrinterSettings`**: `id` (PK, Text), `deviceName` (Text), `deviceAddress` (Text), `vendorId` (Text), `productId` (Text), `paperSize` (Text), `connectionType` (Text), `autoCut` (Boolean), `autoPrint` (Boolean).
18. **`Khatas`**: `id` (PK, Text), `personName` (Text), `openingBalance` (Real), `totalAmount` (Real), `paidAmount` (Real), `remainingBalance` (Real), `date` (DateTime), `createdAt` (DateTime).
19. **`KhataItems`**: `id` (PK, AutoIncrement), `khataId` (Text, FK $\rightarrow$ `Khatas`), `itemName` (Text), `price` (Real), `type` (Text: cashIn, cashOut), `paymentMethod` (Text), `date` (DateTime), `createdAt` (DateTime).

---

## 5. MATHEMATICAL & FINANCIAL FORMULAE

The ERP enforces exact mathematical models across all accounting and manufacturing transactions:

### 5.1 Supplier Balance Reconciliation
$$\text{Updated Balance} = \text{Previous Outstanding} + \text{Bill Amount} - \text{Payment Amount}$$

### 5.2 Workforce Wage Reconciliation
$$\text{Net Wage Balance} = \text{Previous Outstanding} + \text{Task Cost} - \text{Disbursed Amount}$$

### 5.3 Multi-Entity Khata Balance
$$\text{Net Khata Balance} = \text{Opening Balance} + \sum \text{Cash Out (Debit)} - \sum \text{Cash In (Credit)}$$

### 5.4 Unit Manufacturing Cost (BOM)
$$C_{\text{Traila}} = \sum_{i=1}^{M} \text{MaterialCost}_i + \sum_{j=1}^{L} \text{LabourCost}_j + \sum_{k=1}^{O} \text{OverheadCost}_k$$

### 5.5 Vehicle Commercial Profit & Margin
$$\text{Gross Profit} = \text{Sale Price} - C_{\text{Traila}}$$
$$\text{Profit Margin } \% = \left( \frac{\text{Gross Profit}}{\text{Sale Price}} \right) \times 100$$

### 5.6 Global Buyer Debt Settlement
$$\text{Gross Customer Liability} = \text{Current Sale Price} + \text{Prior Global Buyer Debt}$$
$$\text{Customer Net Due} = \text{Gross Customer Liability} - \text{Total Installments Paid}$$

### 5.7 Aggregated Treasury Liquidity
$$\text{Total Available Cash/Bank Liquidity} = \sum_{a \in \text{Accounts}} \text{Balance}(a)$$

---

## 6. NON-FUNCTIONAL REQUIREMENTS

### 6.1 Performance & Latency
- **Sub-50ms Query Latency:** Indexed relational lookups ensure near-instantaneous ledger loading even with tens of thousands of transactions.
- **Smooth 60+ FPS Rendering:** GPU-accelerated Impeller/Skia Flutter Windows engine ensures zero stutter during ledger scrolling and modal transitions.
- **Fast Startup:** Cold boot to interactive dashboard in less than 2.0 seconds.

### 6.2 Data Integrity & Offline Reliability
- **Zero Cloud Dependency:** Operates 100% offline; completely immune to internet service outages.
- **ACID Persistence:** SQLite FFI guarantees zero data corruption during unexpected power cuts or system restarts.
- **Automated Self-Healing:** Automatic startup algorithms backfill legacy opening balance invoices and reconcile sales downpayments.

### 6.3 Security & Confidentiality
- **Air-Gapped Operation:** All financial metrics, customer contacts, profit margins, and procurement costs remain strictly local on the workshop host machine.
- **Internal Margins Confidentiality:** Manufacturing costs and net profit margins are omitted from all customer-facing receipts, printed thermal vouchers, and exported PDFs.

### 6.4 Usability & Ergonomics
- **Window Management:** Frameless custom window chrome with native drag area, responsive constraints, and dedicated sub-window controls on all popup modals.
- **Dual Printing Ergonomics:** Single-click receipt printing with auto-cut and pre-formatted WhatsApp sharing.
- **Lined Density:** High-information density lined lists maximize visible records without vertical clutter.

---

## 7. VERIFICATION MATRIX & SYSTEM SIGNOFF

| Requirement ID | Module / Feature | Verification Method | Status |
|---|---|---|---|
| **REQ-001** | Executive Dashboard KPIs & Quick Actions | Unit & Integration Test | **PASSED** |
| **REQ-002** | Traila Chassis Lifecycle & BOM Accumulation | Mathematical Traceability | **PASSED** |
| **REQ-003** | Supplier Multi-line Bills & Upfront Routing | Dual-Entry Audit Check | **PASSED** |
| **REQ-004** | Labour Piece-Rate Tasks & Wage Disbursements | Balance Invariance Audit | **PASSED** |
| **REQ-005** | Khata Got/Gave Engine & Syncing Toggle | Mathematical Proof Check | **PASSED** |
| **REQ-006** | Commercial Sales, Profit Margin & Global Debt | Financial Reconciliation | **PASSED** |
| **REQ-007** | Treasury Multi-Account & Internal Transfers | Conservation of Money Test | **PASSED** |
| **REQ-008** | Dual Hardware Printing (58/80mm & A4 Vector) | Hardware Emulation / Raster | **PASSED** |
| **REQ-009** | Automated Timestamped Backup & Hot Restore | Snapshot Disaster Recovery | **PASSED** |
| **REQ-010** | Frameless Desktop Chrome & Popup Controls | Windows OS Shell Test | **PASSED** |

---
*End of Software Requirements Specification (SRS) Document.*
