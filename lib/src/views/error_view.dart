import 'package:flutter/material.dart';
import 'package:soflutter/src/core/helpers.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    this.message,
    super.key,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message ?? 'Erro inesperado!',
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (isDebug) ...[
            const SizedBox(height: 12),
            const Divider(),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Detalhes técnicos (Debug)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                _DebugErrorDetails(
                  error: error,
                  stackTrace: stackTrace ?? StackTrace.current,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DebugErrorDetails extends StatelessWidget {
  const _DebugErrorDetails({required this.error, this.stackTrace});
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ERRO:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(error.toString()),
        const SizedBox(height: 16),
        if (stackTrace != null) ...[
          Text(
            'STACK TRACE:',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(stackTrace.toString()),
          ),
        ],
      ],
    );
  }
}
