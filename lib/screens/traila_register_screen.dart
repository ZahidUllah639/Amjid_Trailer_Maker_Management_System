import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/traila.dart';
import 'traila_history_screen.dart';

class TrailaRegisterScreen extends StatefulWidget {
  const TrailaRegisterScreen({super.key});

  @override
  State<TrailaRegisterScreen> createState() => _TrailaRegisterScreenState();
}

class _TrailaRegisterScreenState extends State<TrailaRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  String _filterStatus = 'All';

  void _showAddDialog(BuildContext context) {
    final nextId = context.read<ERPCubit>().getNextTrailaId();
    _idController.text = nextId;
    _nameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_circle_outline_rounded, color: Color(0xFF4F46E5), size: 22),
            SizedBox(width: 10),
            Text('Register New Traila Unit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A unit identifier has been automatically generated. Enter the model specification to register the new chassis.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _idController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Traila Identifier / Code (Auto-Generated)',
                    prefixIcon: const Icon(Icons.tag_rounded, size: 20),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFC7D2FE)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF4F46E5)),
                          SizedBox(width: 4),
                          Text('AUTO', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Traila Name / Model Spec',
                    hintText: 'e.g. 40ft Semi-Trailer Bed',
                    prefixIcon: Icon(Icons.local_shipping_rounded, size: 20),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name/Model is required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final idToUse = _idController.text.trim().isNotEmpty
                    ? _idController.text.trim()
                    : context.read<ERPCubit>().getNextTrailaId();
                context.read<ERPCubit>().addTraila(
                  idToUse,
                  _nameController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Register Unit'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Traila traila) {
    final idController = TextEditingController(text: traila.id);
    final nameController = TextEditingController(text: traila.name);
    DateTime selectedDate = traila.registrationDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit_rounded, color: Color(0xFF4F46E5), size: 22),
              SizedBox(width: 10),
              Text('Edit Traila Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: idController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Traila Identifier (Permanent)',
                      prefixIcon: Icon(Icons.tag_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Traila Name / Model',
                      prefixIcon: Icon(Icons.local_shipping_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Registration Date',
                        prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                      ),
                      child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ERPCubit>().updateTraila(
                  traila.id,
                  newId: idController.text.trim(),
                  name: nameController.text.trim(),
                  registrationDate: selectedDate,
                );
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Traila traila) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 10),
            Text('Delete Traila Unit?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${traila.id} - ${traila.name}"? This will permanently delete all associated material history, labour assignments, and expenses.',
          style: const TextStyle(color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ERPCubit>().deleteTraila(traila.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        if (state.currentTrailaHistoryId != null) {
          return TrailaHistoryScreen(trailaId: state.currentTrailaHistoryId!);
        }

        final allTrailas = state.trailas;
        final pendingCount = allTrailas.where((t) => t.status == TrailaStatus.pending).length;
        final readyCount = allTrailas.where((t) => t.status == TrailaStatus.ready).length;
        final soldCount = allTrailas.where((t) => t.status == TrailaStatus.sold).length;

        final filteredTrailas = allTrailas.where((t) {
          final matchesStatus = _filterStatus == 'All' ||
              t.status.name.toLowerCase() == _filterStatus.toLowerCase();
          final matchesSearch = state.searchQuery.isEmpty ||
              t.id.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              t.name.toLowerCase().contains(state.searchQuery.toLowerCase());
          return matchesStatus && matchesSearch;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Header & Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter Segmented Chips
                Row(
                  children: [
                    _buildFilterChip('All', allTrailas.length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', pendingCount, color: const Color(0xFFF59E0B)),
                    const SizedBox(width: 8),
                    _buildFilterChip('Ready', readyCount, color: const Color(0xFF10B981)),
                    const SizedBox(width: 8),
                    _buildFilterChip('Sold', soldCount, color: const Color(0xFF3B82F6)),
                  ],
                ),

                // Register New Unit Button
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Register New Traila'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Modern Table Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTableHeader(),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    Expanded(
                      child: filteredTrailas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'No trailers match "${state.searchQuery}"'
                                        : 'No trailers found in "$_filterStatus" status',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredTrailas.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) => _TrailaRow(
                                traila: filteredTrailas[index],
                                onEdit: () => _showEditDialog(context, filteredTrailas[index]),
                                onDelete: () => _showDeleteConfirmation(context, filteredTrailas[index]),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int count, {Color? color}) {
    final isSelected = _filterStatus.toLowerCase() == label.toLowerCase();
    final chipColor = color ?? const Color(0xFF4F46E5);

    return InkWell(
      onTap: () => setState(() => _filterStatus = label),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withValues(alpha: 0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? chipColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? chipColor : const Color(0xFF475569),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? chipColor : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('CHASSIS ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 3, child: Text('NAME / MODEL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('REGISTRATION DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('MANUFACTURING COST', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          SizedBox(width: 140, child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
        ],
      ),
    );
  }
}

class _TrailaRow extends StatefulWidget {
  final Traila traila;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TrailaRow({
    required this.traila,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_TrailaRow> createState() => _TrailaRowState();
}

class _TrailaRowState extends State<_TrailaRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final traila = widget.traila;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
        child: Row(
          children: [
            // Monospace Tag ID
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    traila.id,
                    style: const TextStyle(
                      color: Color(0xFF4338CA),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Name
            Expanded(
              flex: 3,
              child: Text(
                traila.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),

            // Date
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM yyyy').format(traila.registrationDate),
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Cost
            Expanded(
              flex: 2,
              child: Text(
                'Rs. ${NumberFormat('#,##0').format(traila.totalManufacturingCost)}',
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ),

            // Status Badge
            Expanded(
              flex: 2,
              child: _StatusBadge(status: traila.status),
            ),

            // Actions
            SizedBox(
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Quick History Button
                  IconButton(
                    icon: const Icon(Icons.history_rounded, size: 19, color: Color(0xFF4F46E5)),
                    tooltip: 'View Material & Labour Ledger',
                    onPressed: () {
                      context.read<ERPCubit>().setTrailaHistoryId(traila.id);
                    },
                  ),

                  // Menu for Edit, Delete, Quick Status Change
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          widget.onEdit();
                          break;
                        case 'delete':
                          widget.onDelete();
                          break;
                        case 'history':
                          context.read<ERPCubit>().setTrailaHistoryId(traila.id);
                          break;
                        case 'pending':
                          context.read<ERPCubit>().updateTrailaStatus(traila.id, TrailaStatus.pending);
                          break;
                        case 'ready':
                          context.read<ERPCubit>().updateTrailaStatus(traila.id, TrailaStatus.ready);
                          break;
                        case 'sold':
                          context.read<ERPCubit>().updateTrailaStatus(traila.id, TrailaStatus.sold);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'history',
                        child: Row(
                          children: [
                            Icon(Icons.history_rounded, size: 18, color: Color(0xFF4F46E5)),
                            SizedBox(width: 10),
                            Text('Production History'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_rounded, size: 18, color: Color(0xFF3B82F6)),
                            SizedBox(width: 10),
                            Text('Edit Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                            SizedBox(width: 10),
                            Text('Delete Traila'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(value: 'pending', child: Text('Mark In Workshop')),
                      const PopupMenuItem(value: 'ready', child: Text('Mark Ready')),
                      const PopupMenuItem(value: 'sold', child: Text('Mark Sold')),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TrailaStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case TrailaStatus.pending:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'IN WORKSHOP';
        break;
      case TrailaStatus.ready:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF047857);
        label = 'READY';
        break;
      case TrailaStatus.sold:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1D4ED8);
        label = 'SOLD';
        break;
    }

    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

