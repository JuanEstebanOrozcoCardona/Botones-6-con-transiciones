import 'package:flutter/material.dart';

/// Punto de entrada principal de la aplicación
void main() {
  runApp(const MyApp());
}

/// Enumeración que define los diferentes estados/pantallas de la aplicación
enum AppState {
  principal,
  pantalla1,
  pantalla2,
  pantalla3,
  pantalla4,
  pantalla5,
  pantalla6,
}

/// CLASE PARA LA LISTA DE TAREAS (Pantalla 3)
class Task {
  final String titulo;
  final String descripcion;
  bool completada;
  final DateTime fechaCreacion;

  Task({
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  void toggleCompletada() {
    completada = !completada;
  }

  @override
  String toString() {
    return 'Task(titulo: $titulo, completada: $completada)';
  }
}

class TodoList {
  List<Task> _tareas = [];

  void agregarTarea(Task tarea) {
    _tareas.add(tarea);
  }

  void completarTarea(int index) {
    if (index >= 0 && index < _tareas.length) {
      _tareas[index].toggleCompletada();
    }
  }

  void eliminarTarea(int index) {
    if (index >= 0 && index < _tareas.length) {
      _tareas.removeAt(index);
    }
  }

  List<Task> get tareas => _tareas;
  
  List<Task> get tareasPendientes => _tareas.where((tarea) => !tarea.completada).toList();
  
  List<Task> get tareasCompletadas => _tareas.where((tarea) => tarea.completada).toList();

  int get totalTareas => _tareas.length;
  int get tareasCompletadasCount => tareasCompletadas.length;
}

/// ENUM PARA CONVERSOR DE TEMPERATURAS (Pantalla 4)
enum TipoTemperatura {
  celsius,
  fahrenheit,
  kelvin
}

/// FUNCIONES PARA LAS DIFERENTES PANTALLAS

// Validador de contraseñas para Pantalla 2
bool validarContrasena(String contrasena) {
  if (contrasena.length < 8) return false;
  
  final RegExp mayuscula = RegExp(r'[A-Z]');
  final RegExp minuscula = RegExp(r'[a-z]');
  final RegExp numero = RegExp(r'[0-9]');
  final RegExp caracterEspecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  
  return mayuscula.hasMatch(contrasena) &&
         minuscula.hasMatch(contrasena) &&
         numero.hasMatch(contrasena) &&
         caracterEspecial.hasMatch(contrasena);
}

String obtenerFortalezaContrasena(String contrasena) {
  if (contrasena.isEmpty) return 'Vacía';
  
  int criterios = 0;
  if (contrasena.length >= 8) criterios++;
  if (RegExp(r'[A-Z]').hasMatch(contrasena)) criterios++;
  if (RegExp(r'[a-z]').hasMatch(contrasena)) criterios++;
  if (RegExp(r'[0-9]').hasMatch(contrasena)) criterios++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(contrasena)) criterios++;
  
  switch (criterios) {
    case 5: return 'Muy Fuerte';
    case 4: return 'Fuerte';
    case 3: return 'Moderada';
    case 2: return 'Débil';
    case 1: return 'Muy Débil';
    default: return 'Inválida';
  }
}

// Conversor de temperaturas para Pantalla 4
double convertirTemperatura(double valor, TipoTemperatura desde, TipoTemperatura hacia) {
  if (desde == hacia) return valor;
  
  // Convertir primero a Celsius
  double celsius;
  switch (desde) {
    case TipoTemperatura.celsius:
      celsius = valor;
      break;
    case TipoTemperatura.fahrenheit:
      celsius = (valor - 32) * 5/9;
      break;
    case TipoTemperatura.kelvin:
      celsius = valor - 273.15;
      break;
  }
  
  // Convertir de Celsius al tipo destino
  switch (hacia) {
    case TipoTemperatura.celsius:
      return celsius;
    case TipoTemperatura.fahrenheit:
      return (celsius * 9/5) + 32;
    case TipoTemperatura.kelvin:
      return celsius + 273.15;
  }
}

String obtenerSimboloTemperatura(TipoTemperatura tipo) {
  switch (tipo) {
    case TipoTemperatura.celsius:
      return '°C';
    case TipoTemperatura.fahrenheit:
      return '°F';
    case TipoTemperatura.kelvin:
      return 'K';
  }
}

// Analizador de texto para Pantalla 5
Map<String, dynamic> analizarTexto(String texto) {
  if (texto.isEmpty) {
    return {
      'palabras': 0,
      'caracteres': 0,
      'vocales': 0,
      'consonantes': 0,
      'palabraMasLarga': '',
      'oraciones': 0,
    };
  }
  
  // Contar caracteres
  int caracteres = texto.length;
  
  // Contar palabras
  List<String> palabras = texto.trim().split(RegExp(r'\s+'));
  int numPalabras = palabras.length;
  
  // Encontrar palabra más larga
  String palabraMasLarga = '';
  for (String palabra in palabras) {
    String palabraLimpia = palabra.replaceAll(RegExp(r'[^\w]'), '');
    if (palabraLimpia.length > palabraMasLarga.length) {
      palabraMasLarga = palabraLimpia;
    }
  }
  
  // Contar vocales y consonantes
  int vocales = 0;
  int consonantes = 0;
  final letras = texto.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚ]'), '').toLowerCase();
  
  for (int i = 0; i < letras.length; i++) {
    if ('aeiouáéíóú'.contains(letras[i])) {
      vocales++;
    } else {
      consonantes++;
    }
  }
  
  // Contar oraciones (aproximado)
  int oraciones = texto.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;
  
  return {
    'palabras': numPalabras,
    'caracteres': caracteres,
    'vocales': vocales,
    'consonantes': consonantes,
    'palabraMasLarga': palabraMasLarga,
    'oraciones': oraciones,
  };
}

/// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Multi-Estado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PaginaPrincipal(),
    );
  }
}

/// Widget principal con estado
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  AppState _estadoActual = AppState.principal;
  final TodoList _todoList = TodoList();

  void _cambiarEstado(AppState nuevoEstado) {
    setState(() {
      _estadoActual = nuevoEstado;
    });
  }

  void _volverAlInicio() {
    _cambiarEstado(AppState.principal);
  }

  @override
  Widget build(BuildContext context) {
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
        switch (current) {
          case AppState.pantalla1:
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: FadeTransition(opacity: animation, child: widget),
            );
          case AppState.pantalla2:
            final rotate = Tween(begin: -0.5, end: 0.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return RotationTransition(turns: rotate, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla3:
            final inAnim = Tween<Offset>(begin: const Offset(-0.3, 0.0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return SlideTransition(position: inAnim, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla4:
            final inAnim4 = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return SlideTransition(position: inAnim4, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla5:
            return SizeTransition(sizeFactor: animation, axis: Axis.vertical, child: FadeTransition(opacity: animation, child: widget));
          case AppState.pantalla6:
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
  /// PANTALLA PRINCIPAL
  /// ============================================================================
  Widget _buildPantallaPrincipal() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Selecciona una opción',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Calculadora de IMC', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Validador de Contraseñas', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Lista de Tareas', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla4),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 58, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Conversor de Temperaturas', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla5),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Analizador de Texto', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _cambiarEstado(AppState.pantalla6),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Pantalla 6', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================================================
  /// PANTALLA 1 - CALCULADORA DE IMC
  /// ============================================================================
  Widget _buildPantalla1() {
    double? peso;
    double? altura;
    String resultado = '';
    String clasificacion = '';
    Color colorResultado = Colors.blue;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Calculadora de IMC'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monitor_weight, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text('Calculadora de IMC', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 10),
                const Text('Ingresa tu peso y altura para calcular tu Índice de Masa Corporal', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade100)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Peso (kg)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    TextField(keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Ejemplo: 70.5', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.fitness_center), suffixText: 'kg'), onChanged: (value) { peso = double.tryParse(value); }),
                  ]),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade100)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Altura (m)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    TextField(keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Ejemplo: 1.75', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.height), suffixText: 'm'), onChanged: (value) { altura = double.tryParse(value); }),
                    const SizedBox(height: 8),
                    const Text('Nota: Ingresa la altura en metros (1.75 m = 175 cm)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    if (peso == null || altura == null || altura == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor ingresa peso y altura válidos'), backgroundColor: Colors.red));
                      return;
                    }
                    double imc = peso! / (altura! * altura!);
                    String clasif; Color color;
                    if (imc < 18.5) { clasif = 'Bajo peso'; color = Colors.orange; } 
                    else if (imc < 25) { clasif = 'Peso normal'; color = Colors.green; } 
                    else if (imc < 30) { clasif = 'Sobrepeso'; color = Colors.orange; } 
                    else { clasif = 'Obesidad'; color = Colors.red; }
                    setState(() { resultado = 'Tu IMC es: ${imc.toStringAsFixed(2)}'; clasificacion = 'Clasificación: $clasif'; colorResultado = color; });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calculate), SizedBox(width: 10), Text('Calcular IMC', style: TextStyle(fontSize: 18))]),
                ),
                const SizedBox(height: 30),

                if (resultado.isNotEmpty) Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: colorResultado.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: colorResultado)), child: Column(children: [
                  Text(resultado, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorResultado), textAlign: TextAlign.center),
                  const SizedBox(height: 10), Text(clasificacion, style: TextStyle(fontSize: 18, color: colorResultado), textAlign: TextAlign.center),
                ])),
                const SizedBox(height: 20),

                if (resultado.isNotEmpty) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Clasificaciones OMS:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 8),
                  Text('• Bajo peso: menos de 18.5'), Text('• Normal: 18.5 - 24.9'), Text('• Sobrepeso: 25 - 29.9'), Text('• Obesidad: 30 o más'),
                ])),
                const SizedBox(height: 30),

                ElevatedButton(onPressed: _volverAlInicio, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), child: const Text('Regresar al Inicio')),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ============================================================================
  /// PANTALLA 2 - VALIDADOR DE CONTRASEÑAS
  /// ============================================================================
  Widget _buildPantalla2() {
    String contrasena = '';
    bool esValida = false;
    String fortaleza = '';
    Color colorFortaleza = Colors.grey;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Validador de Contraseñas'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text('Validador de Contraseñas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                const Text('Verifica la seguridad de tu contraseña', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade100)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Contraseña', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu contraseña',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      onChanged: (value) {
                        setState(() {
                          contrasena = value;
                          esValida = validarContrasena(value);
                          fortaleza = obtenerFortalezaContrasena(value);
                          colorFortaleza = fortaleza == 'Muy Fuerte' ? Colors.green : 
                                         fortaleza == 'Fuerte' ? Colors.lightGreen :
                                         fortaleza == 'Moderada' ? Colors.orange :
                                         fortaleza == 'Débil' ? Colors.orangeAccent : Colors.red;
                        });
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 30),

                if (contrasena.isNotEmpty) Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: colorFortaleza.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: colorFortaleza)), child: Column(children: [
                  Icon(esValida ? Icons.check_circle : Icons.error, color: colorFortaleza, size: 50),
                  const SizedBox(height: 10),
                  Text(esValida ? 'CONTRASEÑA VÁLIDA' : 'CONTRASEÑA INVÁLIDA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorFortaleza)),
                  const SizedBox(height: 10),
                  Text('Fortaleza: $fortaleza', style: TextStyle(fontSize: 18, color: colorFortaleza)),
                ])),
                const SizedBox(height: 30),

                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Criterios de validación:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), SizedBox(height: 8),
                  Text('• Mínimo 8 caracteres'), Text('• Al menos una mayúscula (A-Z)'), Text('• Al menos una minúscula (a-z)'), Text('• Al menos un número (0-9)'), Text('• Al menos un carácter especial (!@#\$% etc.)'),
                ])),
                const SizedBox(height: 30),

                ElevatedButton(onPressed: _volverAlInicio, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), child: const Text('Regresar al Inicio')),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ============================================================================
  /// PANTALLA 3 - LISTA DE TAREAS CON CLASES
  /// ============================================================================
  Widget _buildPantalla3() {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    int filtro = 0; // 0: Todas, 1: Pendientes, 2: Completadas

    return StatefulBuilder(
      builder: (context, setState) {
        List<Task> tareasFiltradas = filtro == 0 ? _todoList.tareas : 
                                   filtro == 1 ? _todoList.tareasPendientes : 
                                   _todoList.tareasCompletadas;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de Tareas'),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Nueva Tarea'),
                      content: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
                        TextField(controller: descripcionController, decoration: const InputDecoration(labelText: 'Descripción')),
                      ]),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                        ElevatedButton(onPressed: () {
                          if (tituloController.text.isNotEmpty) {
                            setState(() {
                              _todoList.agregarTarea(Task(
                                titulo: tituloController.text,
                                descripcion: descripcionController.text,
                              ));
                              tituloController.clear();
                              descripcionController.clear();
                              Navigator.pop(context);
                            });
                          }
                        }, child: const Text('Agregar')),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              const Text('Filtrar:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              ChoiceChip(label: const Text('Todas'), selected: filtro == 0, onSelected: (_) => setState(() => filtro = 0)),
              const SizedBox(width: 10),
              ChoiceChip(label: const Text('Pendientes'), selected: filtro == 1, onSelected: (_) => setState(() => filtro = 1)),
              const SizedBox(width: 10),
              ChoiceChip(label: const Text('Completadas'), selected: filtro == 2, onSelected: (_) => setState(() => filtro = 2)),
            ])),
            
            Expanded(child: ListView.builder(
              itemCount: tareasFiltradas.length,
              itemBuilder: (context, index) {
                final tarea = tareasFiltradas[index];
                return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: ListTile(
                  leading: IconButton(icon: Icon(tarea.completada ? Icons.check_circle : Icons.radio_button_unchecked, color: tarea.completada ? Colors.green : Colors.grey), onPressed: () => setState(() => _todoList.completarTarea(_todoList.tareas.indexOf(tarea)))),
                  title: Text(tarea.titulo, style: TextStyle(decoration: tarea.completada ? TextDecoration.lineThrough : TextDecoration.none)),
                  subtitle: Text(tarea.descripcion),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _todoList.eliminarTarea(_todoList.tareas.indexOf(tarea)))),
                ));
              },
            )),
            
            Container(padding: const EdgeInsets.all(16), color: Colors.orange.shade50, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total: ${_todoList.totalTareas}'), Text('Completadas: ${_todoList.tareasCompletadasCount}'), Text('Pendientes: ${_todoList.tareasPendientes.length}'),
            ])),
          ]),
          floatingActionButton: FloatingActionButton(onPressed: _volverAlInicio, backgroundColor: Colors.orange, child: const Icon(Icons.home)),
        );
      },
    );
  }

  /// ============================================================================
  /// PANTALLA 4 - CONVERSOR DE TEMPERATURAS
  /// ============================================================================
  Widget _buildPantalla4() {
    double valor = 0;
    TipoTemperatura tipoDesde = TipoTemperatura.celsius;
    TipoTemperatura tipoHacia = TipoTemperatura.fahrenheit;
    double resultado = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Conversor de Temperaturas'),
            backgroundColor: const Color.fromARGB(255, 66, 58, 46),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.thermostat, size: 80, color: Colors.brown),
                const SizedBox(height: 20),
                const Text('Conversor de Temperaturas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown)),
                const SizedBox(height: 10),
                const Text('Convierte entre Celsius, Fahrenheit y Kelvin', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 40),

                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.brown.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.brown.shade100)), child: Column(children: [
                  const Text('Valor a convertir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)), SizedBox(height: 8),
                  TextField(keyboardType: TextInputType.number, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.numbers)), onChanged: (value) => setState(() { valor = double.tryParse(value) ?? 0; })),
                ])),
                const SizedBox(height: 20),

                Row(children: [
                  Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.brown.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.brown.shade100)), child: Column(children: [
                    const Text('De:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)), SizedBox(height: 8),
                    DropdownButton<TipoTemperatura>(value: tipoDesde, onChanged: (TipoTemperatura? nuevo) => setState(() => tipoDesde = nuevo!), items: TipoTemperatura.values.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo.toString().split('.').last))).toList(), isExpanded: true),
                  ]))),
                  const SizedBox(width: 10),
                  Expanded(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.brown.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.brown.shade100)), child: Column(children: [
                    const Text('A:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)), SizedBox(height: 8),
                    DropdownButton<TipoTemperatura>(value: tipoHacia, onChanged: (TipoTemperatura? nuevo) => setState(() => tipoHacia = nuevo!), items: TipoTemperatura.values.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo.toString().split('.').last))).toList(), isExpanded: true),
                  ]))),
                ]),
                const SizedBox(height: 30),

                ElevatedButton(onPressed: () => setState(() { resultado = convertirTemperatura(valor, tipoDesde, tipoHacia); }), style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.autorenew), SizedBox(width: 10), Text('Convertir', style: TextStyle(fontSize: 18))])),
                const SizedBox(height: 30),

                if (valor != 0) Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.brown.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.brown)), child: Column(children: [
                  Text('$valor ${obtenerSimboloTemperatura(tipoDesde)} = ${resultado.toStringAsFixed(2)} ${obtenerSimboloTemperatura(tipoHacia)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown), textAlign: TextAlign.center),
                ])),
                const SizedBox(height: 30),

                ElevatedButton(onPressed: _volverAlInicio, style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), child: const Text('Regresar al Inicio')),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ============================================================================
  /// PANTALLA 5 - ANALIZADOR DE TEXTO
  /// ============================================================================
  Widget _buildPantalla5() {
    String texto = '';
    Map<String, dynamic> estadisticas = {};

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Analizador de Texto'),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.analytics, size: 80, color: Colors.purple),
                const SizedBox(height: 20),
                const Text('Analizador de Texto', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 10),
                const Text('Obtén estadísticas detalladas de tu texto', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 40),

                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purple.shade100)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Ingresa tu texto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)), SizedBox(height: 8),
                  TextField(maxLines: 5, decoration: InputDecoration(hintText: 'Escribe o pega tu texto aquí...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: const Icon(Icons.text_fields)), onChanged: (value) => setState(() { texto = value; })),
                ])),
                const SizedBox(height: 20),

                ElevatedButton(onPressed: () => setState(() { estadisticas = analizarTexto(texto); }), style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.analytics), SizedBox(width: 10), Text('Analizar Texto', style: TextStyle(fontSize: 18))])),
                const SizedBox(height: 30),

                if (estadisticas.isNotEmpty && texto.isNotEmpty) Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.purple)), child: Column(children: [
                  const Text('ESTADÍSTICAS DEL TEXTO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)), SizedBox(height: 15),
                  _buildEstadistica('Palabras', estadisticas['palabras'].toString()),
                  _buildEstadistica('Caracteres', estadisticas['caracteres'].toString()),
                  _buildEstadistica('Vocales', estadisticas['vocales'].toString()),
                  _buildEstadistica('Consonantes', estadisticas['consonantes'].toString()),
                  _buildEstadistica('Oraciones', estadisticas['oraciones'].toString()),
                  if (estadisticas['palabraMasLarga'].isNotEmpty) _buildEstadistica('Palabra más larga', estadisticas['palabraMasLarga']),
                ])),
                const SizedBox(height: 30),

                ElevatedButton(onPressed: _volverAlInicio, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)), child: const Text('Regresar al Inicio')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstadistica(String titulo, String valor) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(valor, style: const TextStyle(fontSize: 16, color: Colors.purple)),
    ]));
  }

  /// ============================================================================
  /// PANTALLA 6 - MANTENIDA IGUAL
  /// ============================================================================
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