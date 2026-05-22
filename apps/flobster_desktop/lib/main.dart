import 'package:flutter/material.dart';

void main() {
  runApp(const FlobsterDesktopApp());
}

class FlobsterDesktopApp extends StatelessWidget {
  const FlobsterDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fLOBster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF246BFE),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
      ),
      home: const ContactManagementShell(),
    );
  }
}

enum ContactSection {
  people('People'),
  companies('Companies'),
  organizations('Organizations');

  const ContactSection(this.label);

  final String label;
}

class ContactRecord {
  const ContactRecord({
    required this.name,
    required this.subtitle,
    required this.email,
    required this.phone,
    required this.category,
    required this.tags,
    required this.updatedLabel,
  });

  final String name;
  final String subtitle;
  final String email;
  final String phone;
  final String category;
  final List<String> tags;
  final String updatedLabel;
}

const _records = <ContactSection, List<ContactRecord>>{
  ContactSection.people: [
    ContactRecord(
      name: 'Anika Rao',
      subtitle: 'Operations Lead, Northwind Trading',
      email: 'anika.rao@example.com',
      phone: '+1 415 010 1142',
      category: 'Partner',
      tags: ['Vendor', 'Priority'],
      updatedLabel: 'Today',
    ),
    ContactRecord(
      name: 'Mateo Silva',
      subtitle: 'Procurement, Contoso Foods',
      email: 'mateo.silva@example.com',
      phone: '+1 212 010 8821',
      category: 'Customer',
      tags: ['Contract'],
      updatedLabel: 'Yesterday',
    ),
  ],
  ContactSection.companies: [
    ContactRecord(
      name: 'Northwind Trading',
      subtitle: 'Food distribution company',
      email: 'hello@northwind.example',
      phone: '+1 415 010 0100',
      category: 'Supplier',
      tags: ['Priority'],
      updatedLabel: 'Today',
    ),
  ],
  ContactSection.organizations: [
    ContactRecord(
      name: 'City Commerce Office',
      subtitle: 'Government services organization',
      email: 'office@citycommerce.example',
      phone: '+1 650 010 4100',
      category: 'Government',
      tags: ['Compliance'],
      updatedLabel: 'May 20',
    ),
  ],
};

class ContactManagementShell extends StatefulWidget {
  const ContactManagementShell({super.key});

  @override
  State<ContactManagementShell> createState() => _ContactManagementShellState();
}

class _ContactManagementShellState extends State<ContactManagementShell> {
  ContactSection _section = ContactSection.people;
  int _selectedIndex = 0;

  List<ContactRecord> get _visibleRecords => _records[_section]!;

  ContactRecord get _selectedRecord => _visibleRecords[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: 0,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  Icons.business_center_outlined,
                  color: colorScheme.primary,
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.contacts_outlined),
                  selectedIcon: Icon(Icons.contacts),
                  label: Text('Contacts'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  _Header(
                    selectedSection: _section,
                    onSectionChanged: (section) {
                      setState(() {
                        _section = section;
                        _selectedIndex = 0;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final showPreview = constraints.maxWidth >= 920;

                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: _RecordTable(
                                section: _section,
                                records: _visibleRecords,
                                selectedIndex: _selectedIndex,
                                onSelected: (index) {
                                  setState(() => _selectedIndex = index);
                                },
                              ),
                            ),
                            if (showPreview) ...[
                              const VerticalDivider(width: 1),
                              SizedBox(
                                width: 340,
                                child: _PreviewPane(record: _selectedRecord),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedSection,
    required this.onSectionChanged,
  });

  final ContactSection selectedSection;
  final ValueChanged<ContactSection> onSectionChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 860;

        final title = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text('Standard user'),
          ],
        );

        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SegmentedButton<ContactSection>(
                segments: ContactSection.values
                    .map(
                      (section) => ButtonSegment<ContactSection>(
                        value: section,
                        label: Text(section.label),
                      ),
                    )
                    .toList(),
                selected: {selectedSection},
                onSelectionChanged: (value) => onSectionChanged(value.first),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('New'),
            ),
          ],
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [title, const SizedBox(height: 12), controls],
                )
              : Row(
                  children: [
                    Expanded(child: title),
                    controls,
                  ],
                ),
        );
      },
    );
  }
}

class _RecordTable extends StatelessWidget {
  const _RecordTable({
    required this.section,
    required this.records,
    required this.selectedIndex,
    required this.onSelected,
  });

  final ContactSection section;
  final List<ContactRecord> records;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search ${section.label.toLowerCase()}',
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Updated')),
                  ],
                  rows: [
                    for (final (index, record) in records.indexed)
                      DataRow(
                        selected: index == selectedIndex,
                        onSelectChanged: (_) => onSelected(index),
                        cells: [
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(record.name),
                                Text(
                                  record.subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(record.category)),
                          DataCell(Text(record.updatedLabel)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPane extends StatelessWidget {
  const _PreviewPane({required this.record});

  final ContactRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 28, child: Text(record.name.characters.first)),
          const SizedBox(height: 18),
          Text(
            record.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(record.subtitle),
          const SizedBox(height: 24),
          _PreviewField(
            icon: Icons.mail_outline,
            label: 'Email',
            value: record.email,
          ),
          _PreviewField(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: record.phone,
          ),
          _PreviewField(
            icon: Icons.category_outlined,
            label: 'Category',
            value: record.category,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final tag in record.tags) Chip(label: Text(tag))],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
