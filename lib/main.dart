import 'package:flutter/material.dart';
import 'engine/termux_engine.dart';

void main() {
  runApp(const ClawdStudioApp());
}

class ClawdStudioApp extends StatelessWidget {
  const ClawdStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF79A7FF);
    return MaterialApp(
      title: 'ClawdStudio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          surface: const Color(0xFF121A2B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A1020),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF121A2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const StudioShell(),
    );
  }
}

class StudioShell extends StatefulWidget {
  const StudioShell({super.key});

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    EngineScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory),
            label: 'Engine',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [colors.primary, colors.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.code_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ClawdStudio',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Your mobile coding workspace',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Build from your phone.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'A Flutter interface for the Clawd-Code agent. The app foundation is in place; the real engine connection is still being built.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 22),
        const _StatusCard(
          icon: Icons.link_off_rounded,
          title: 'Agent engine',
          status: 'Not connected',
          detail: 'No engine process or bridge is running from this app yet.',
          tone: _StatusTone.warning,
        ),
        const SizedBox(height: 12),
        const _StatusCard(
          icon: Icons.key_rounded,
          title: 'AI provider',
          status: 'Not configured',
          detail:
              'No API key has been requested or stored by this foundation build.',
          tone: _StatusTone.neutral,
        ),
        const SizedBox(height: 12),
        const _StatusCard(
          icon: Icons.folder_open_rounded,
          title: 'Workspace',
          status: 'Not selected',
          detail: 'Repository and local file operations are not available yet.',
          tone: _StatusTone.neutral,
        ),
        const SizedBox(height: 24),
        Text(
          'Next milestone',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        const _MilestoneRow(
          number: '01',
          title: 'Prove Android engine runtime',
          detail: 'Connect to real Clawd-Code and run one safe tool.',
        ),
        const _MilestoneRow(
          number: '02',
          title: 'Configure a provider securely',
          detail: 'Store credentials with Android secure storage.',
        ),
        const _MilestoneRow(
          number: '03',
          title: 'Review and apply code changes',
          detail: 'Workspace, diffs, approvals and tests.',
        ),
      ],
    );
  }
}

class EngineScreen extends StatefulWidget {
  const EngineScreen({super.key});

  @override
  State<EngineScreen> createState() => _EngineScreenState();
}

class _EngineScreenState extends State<EngineScreen> {
  bool _checking = false;
  bool _running = false;
  Map<String, Object?>? _status;
  Map<String, Object?>? _diagnostic;
  String? _error;

  Future<void> _checkSetup() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final status = await TermuxEngine.checkStatus();
      if (!mounted) return;
      setState(() => _status = status);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'Native Android bridge unavailable: $error');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _runDiagnostic() async {
    setState(() {
      _running = true;
      _diagnostic = null;
      _error = null;
    });
    try {
      final result = await TermuxEngine.runDiagnostic();
      if (!mounted) return;
      setState(() {
        _diagnostic = result;
        if (result['ok'] != true) {
          _error = (result['error'] as String?) ??
              'Termux did not confirm a successful diagnostic.';
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'Unable to run Termux diagnostic: $error');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final installed = _status?['installed'] == true;
    final permission = _status?['permissionGranted'] == true;
    final service = _status?['serviceAvailable'] == true;
    final connected = _diagnostic?['ok'] == true;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Text(
          'Engine setup',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Clawd-Code is a Python coding-agent engine, not an AI model. This step checks the optional Termux companion runtime; it does not claim that the coding agent is running.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      connected ? Icons.check_circle_outline : Icons.terminal,
                      color: connected ? colors.primary : colors.tertiary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        connected
                            ? 'Termux diagnostic passed'
                            : 'Termux runtime diagnostic',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _RevisionLine(
                  label: 'Upstream repository',
                  value: 'GPT-AGI / Clawd-Code',
                ),
                const _RevisionLine(
                  label: 'Inspected main commit',
                  value: '5a5e4dd8d6c4',
                ),
                const _RevisionLine(label: 'License', value: 'MIT (upstream)'),
                _RevisionLine(
                  label: 'Termux installed',
                  value: _status == null ? 'Not checked' : (installed ? 'Yes' : 'No'),
                ),
                _RevisionLine(
                  label: 'Run-command permission',
                  value: _status == null
                      ? 'Not checked'
                      : (permission ? 'Granted' : 'Not granted'),
                ),
                _RevisionLine(
                  label: 'RunCommand service',
                  value: _status == null
                      ? 'Not checked'
                      : (service ? 'Available' : 'Unavailable'),
                ),
                if (_diagnostic != null)
                  _RevisionLine(
                    label: 'Diagnostic result',
                    value: connected ? 'Verified marker returned' : 'Failed',
                  ),
                if ((_diagnostic?['stdout'] as String?)?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text('Output', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  SelectableText((_diagnostic?['stdout'] as String).trim()),
                ],
                if ((_diagnostic?['stderr'] as String?)?.isNotEmpty == true)
                  SelectableText(
                    'stderr: ${_diagnostic?['stderr']}',
                    style: TextStyle(color: colors.error),
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: colors.error)),
                ],
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _checking ? null : _checkSetup,
                  icon: _checking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(_checking ? 'Checking…' : 'Check Termux setup'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _running ? null : _runDiagnostic,
                  icon: _running
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_running ? 'Running diagnostic…' : 'Run safe diagnostic'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Setup requirements',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const _ChecklistLine(text: 'Install Termux from an official source and open it once.'),
        const _ChecklistLine(text: 'Enable allow-external-apps=true in ~/.termux/termux.properties, then restart Termux.'),
        const _ChecklistLine(text: 'Grant ClawdStudio the “Run commands in Termux environment” permission in Android app settings.'),
        const _ChecklistLine(text: 'The diagnostic runs only a fixed printf command; arbitrary shell commands are not exposed.'),
        const SizedBox(height: 10),
        Text(
          'This is only a transport diagnostic. The real Clawd-Code agent loop, provider calls, and workspace tools are not integrated yet.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Provider configuration and GitHub connection will appear here after their secure workflows are implemented.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        const _SettingsRow(
          icon: Icons.smart_toy_outlined,
          title: 'AI providers',
          subtitle: 'Not configured · setup not implemented',
        ),
        const _SettingsRow(
          icon: Icons.account_tree_outlined,
          title: 'GitHub',
          subtitle: 'Not connected · OAuth not implemented',
        ),
        const _SettingsRow(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'Dark by default · light theme supported; selector planned',
        ),
        const _SettingsRow(
          icon: Icons.info_outline_rounded,
          title: 'About ClawdStudio',
          subtitle: 'Preview foundation · v0.1.0',
        ),
        const SizedBox(height: 18),
        Text(
          'Provider availability, pricing and model capabilities will be verified from official sources before they are shown as supported.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

enum _StatusTone { warning, neutral }

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.detail,
    required this.tone,
  });
  final IconData icon;
  final String title;
  final String status;
  final String detail;
  final _StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = tone == _StatusTone.warning
        ? colors.tertiary
        : colors.onSurfaceVariant;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.35,
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

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.number,
    required this.title,
    required this.detail,
  });
  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              number,
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RevisionLine extends StatelessWidget {
  const _RevisionLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistLine extends StatelessWidget {
  const _ChecklistLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.radio_button_unchecked_rounded, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        minVerticalPadding: 12,
        leading: Icon(icon, color: colors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
