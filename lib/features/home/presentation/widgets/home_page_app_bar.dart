import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageAppBar extends StatelessWidget {
  static final Uri _facebookAppUri = Uri.parse(
    'fb://facewebmodal/f?href=https://www.facebook.com/profile.php?id=100078017859101',
  );

  static final Uri _facebookPageUrl = Uri.parse(
    'https://www.facebook.com/profile.php?id=100078017859101',
  );

  static final Uri _mapsUrl = Uri.parse(
    'https://maps.app.goo.gl/VsSksL3s5ionVx7f8',
  );

  const HomePageAppBar({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Icon(Icons.eco, color: Theme.of(context).iconTheme.color, size: 28),
          const SizedBox(width: 8),
          Text(
            'Guía Botánica',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => _showHelpSheet(context),
          icon: const Icon(Icons.help_outline, size: 30, weight: 900),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(36, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          tooltip: 'Ayuda',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: IconButton(
            onPressed: () => _showInfoSheet(context),
            icon: const Icon(Icons.info_outline, size: 30, weight: 900),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(36, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            tooltip: 'Información',
          ),
        ),
      ],
    );
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Como usar la Guia Botanica?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 14),
                  _SheetSectionText(
                    'Explora el catalogo: Navega por la lista de plantas. Las que estan en gris aun no han sido descubiertas.',
                  ),
                  SizedBox(height: 10),
                  _SheetSectionText(
                    'Usa las herramientas: Toca el boton de Explorar (Radar) para encontrar especies cerca de ti, o usa la Camara si encuentras un codigo QR en el jardin.',
                  ),
                  SizedBox(height: 10),
                  _SheetSectionText(
                    'Desbloquea recompensas: Al encontrar una especie, se registrara en tu progreso y podras leer datos curiosos sobre ella.',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final Color subdued = Colors.grey.shade700;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Acerca del Jardin Botanico',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ubicacion y Horarios',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: subdued,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Direccion: Av. Ramon Rivero y empalme, Cochabamba.',
                    style: TextStyle(fontSize: 12, color: subdued),
                  ),
                  const SizedBox(height: 2),
                  TextButton.icon(
                    onPressed: () => _openMapsLocation(context),
                    icon: const Icon(Icons.location_on_outlined, size: 14),
                    label: const Text('Abrir ubicacion'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 26),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      textStyle: const TextStyle(fontSize: 11),
                      alignment: Alignment.centerLeft,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Lunes a Viernes: 09:00 - 16:00',
                    style: TextStyle(fontSize: 12, color: subdued),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => _openFacebookPage(context),
                    icon: const Icon(Icons.facebook, size: 16),
                    label: const Text('Visitar pagina oficial'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 34),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Acerca de la App',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Guia Botanica v0.1.0',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sistema desarrollado por Christian Rojas Blum como Trabajo de Grado.',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openFacebookPage(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    bool appOpened = false;

    try {
      appOpened = await launchUrl(
        _facebookAppUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } on PlatformException {
      appOpened = false;
    }

    if (appOpened) {
      return;
    }

    final webOpened = await launchUrl(
      _facebookPageUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!webOpened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la pagina oficial.')),
      );
    }
  }

  Future<void> _openMapsLocation(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final opened = await launchUrl(
      _mapsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps.')),
      );
    }
  }
}

class _SheetSectionText extends StatelessWidget {
  const _SheetSectionText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, height: 1.35, color: Colors.grey.shade800),
    );
  }
}
