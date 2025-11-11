import 'package:flutter/material.dart';

/// Punto de entrada principal de la aplicación
/// Esta es la primera función que se ejecuta cuando inicia la app
void main() {
  runApp(const MyApp());
}

/// Enumeración que define los diferentes estados/pantallas de la aplicación
/// Usar un enum es una buena práctica para manejar estados finitos y evitar errores
enum AppState {
  principal, // Estado inicial con los 3 botones
  pantalla1, // Primer estado secundario
  pantalla2, // Segundo estado secundario
  pantalla3,
  pantalla4, // Tercer estado secundario
  pantalla5,
  pantalla6,
}

/// Widget raíz de la aplicación (sin estado - StatelessWidget)
/// Este widget configura el tema y la estructura base de la app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la aplicación (se muestra en el task manager del dispositivo)
      title: 'App Multi-Estado',

      // Configuración del tema visual de la aplicación
      theme: ThemeData(
        // Genera un esquema de colores basado en un color semilla
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // Usa Material 3 para un diseño moderno
        useMaterial3: true,
      ),

      // Define la pantalla inicial de la aplicación
      home: const PaginaPrincipal(),
    );
  }
}

/// Widget principal con estado (StatefulWidget)
/// Este widget puede cambiar su estado interno y reconstruirse cuando sea necesario
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

/// Clase State que maneja el estado mutable de PaginaPrincipal
/// Aquí es donde se guarda y gestiona el estado actual de la aplicación
class _PaginaPrincipalState extends State<PaginaPrincipal> {
  // Variable que guarda el estado actual de la aplicación
  // Inicialmente está en el estado principal
  AppState _estadoActual = AppState.principal;

  /// Método para cambiar el estado de la aplicación
  /// Parámetro: nuevoEstado - El estado al que queremos cambiar
  void _cambiarEstado(AppState nuevoEstado) {
    setState(() {
      // setState() le indica a Flutter que el estado cambió
      // y que debe reconstruir el widget con los nuevos valores
      _estadoActual = nuevoEstado;
    });
  }

  /// Método para volver al estado principal desde cualquier otra pantalla
  void _volverAlInicio() {
    _cambiarEstado(AppState.principal);
  }

  @override
  Widget build(BuildContext context) {
    // Usamos AnimatedSwitcher para aplicar una animación al cambiar de estado.
    // Cada pantalla devuelve un widget con una key única basada en el estado
    // para que AnimatedSwitcher detecte los cambios.
    Widget child = switch (_estadoActual) {
      AppState.principal => _buildPantallaPrincipal(),
      AppState.pantalla1 => _buildPantalla1(),
      AppState.pantalla2 => _buildPantalla2(),
      AppState.pantalla3 => _buildPantalla3(),
      AppState.pantalla4 => _buildPantalla4(),
      AppState.pantalla5 => _buildPantalla5(),
      AppState.pantalla6 => _buildPantalla6(),
    };

  final current = _estadoActual;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (widget, animation) {
        // Choose a different animation per target state
        switch (current) {
          case AppState.pantalla1:
            // Scale + Fade
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: FadeTransition(opacity: animation, child: widget),
            );
          case AppState.pantalla2:
            // Rotation + Fade
            final rotate = Tween(begin: -0.5, end: 0.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return RotationTransition(turns: rotate, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla3:
            // Slide from left + Fade
            final inAnim = Tween<Offset>(begin: const Offset(-0.3, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return SlideTransition(position: inAnim, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla4:
            // Slide from bottom + Fade (original)
            final inAnim4 = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return SlideTransition(position: inAnim4, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla5:
            // Size transition (vertical) + Fade
            return SizeTransition(sizeFactor: animation, axis: Axis.vertical, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla6:
            // Scale down+up with fade
            return ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)), child: FadeTransition(opacity: animation, child: widget));
          default:
            return FadeTransition(opacity: animation, child: widget);
        }
      },
      child: Container(
        key: ValueKey(_estadoActual),
        child: child,
      ),
    );
  }

  /// ============================================================================
  /// SCAFFOLD PRINCIPAL
  /// Pantalla inicial que muestra los 3 botones para navegar a otros estados
  /// ============================================================================
  Widget _buildPantallaPrincipal() {
    return Scaffold(
      // AppBar: Barra superior de la aplicación
      appBar: AppBar(
        // Título centrado en la barra superior
        title: const Text('Pantalla Principal'),
        // Color de fondo de la barra usando el color primario del tema
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Centra el título en la barra (especialmente útil para iOS)
        centerTitle: true,
      ),

      // Body: Contenido principal de la pantalla
      // Usamos SingleChildScrollView para asegurar que en pantallas pequeñas
      // los botones sean accesibles mediante scroll en lugar de quedar
      // ocultos. Mantengo el padding y el centrado horizontal.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            // Centra los elementos verticalmente en la pantalla
            mainAxisAlignment: MainAxisAlignment.center,
            // Extiende la columna al ancho completo disponible
            crossAxisAlignment: CrossAxisAlignment.stretch,

            // Lista de widgets hijos
            children: [
              // Widget de texto para el título principal
              const Text(
                'Selecciona una opción',
                // TextAlign.center centra el texto horizontalmente
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              // SizedBox: Crea un espacio vacío entre widgets
              const SizedBox(height: 40),

              // Primer botón - Lleva al Estado 1
              ElevatedButton(
                // onPressed: Función que se ejecuta al presionar el botón
                onPressed: () => _cambiarEstado(AppState.pantalla1),
                // Estilo del botón
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 1',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              // Espacio entre botones
              const SizedBox(height: 20),

              // Segundo botón - Lleva al Estado 2
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 2',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              // Espacio entre botones
              const SizedBox(height: 20),

              // Tercer botón - Lleva al Estado 3
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 3',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Cuarto botón - Lleva al Estado 4
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla4),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 58, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 4',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Quinto botón - Lleva al Estado 5
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla5),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 5',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Sexto botón - Lleva al Estado 6
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla6),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pantalla 6',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // (Se mantienen solo seis botones en el menú principal)
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================================
  /// SCAFFOLD ESTADO 1
  /// Primera pantalla secundaria con título, contenedor y botón de regreso
  /// ============================================================================
  Widget _buildPantalla1() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 1'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 1',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================================
  /// SCAFFOLD ESTADO 2
  /// Segunda pantalla secundaria con título, contenedor y botón de regreso
  /// ============================================================================
  Widget _buildPantalla2() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 2'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 2',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================================
  /// SCAFFOLD ESTADO 3
  /// Tercera pantalla secundaria con título, contenedor y botón de regreso
  /// ============================================================================
  Widget _buildPantalla3() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 3'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 3',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPantalla4() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 4'),
        backgroundColor: const Color.fromARGB(255, 66, 58, 46),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 4',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 58, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPantalla5() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 5'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 5',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPantalla6() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla 6'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor con texto lorem
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Esta es la pantalla 6',
                  style: TextStyle(fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para regresar
              ElevatedButton(
                onPressed: _volverAlInicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}