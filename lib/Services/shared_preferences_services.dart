// Importa a biblioteca 'dart:ffi', que permite a interoperabilidade com código C.
// Neste arquivo específico, ela não está sendo utilizada e pode ser removida.
// import 'dart:ffi';

// Importa a biblioteca principal do Flutter (material.dart), necessária para usar
// widgets e funcionalidades como 'debugPrint'.
import 'package:flutter/material.dart';

// Importa o pacote 'shared_preferences', que é a biblioteca usada para
// persistir dados simples de chave-valor no armazenamento local do dispositivo.
import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferencesService] é uma classe de serviço que abstrai e gerencia
/// o acesso ao SharedPreferences.
///
/// Ela é implementada como um Singleton, o que garante que haverá apenas uma
/// instância desta classe em toda a aplicação. Isso evita conflitos e gerencia
/// o acesso ao armazenamento de forma centralizada.
class SharedPreferencesService {
  // `_instance` é a variável estática que armazenará a única instância da classe.
  // O `?` indica que ela pode ser nula inicialmente.
  static SharedPreferencesService? _instance;

  // `_preferences` é a variável estática que armazenará a instância do SharedPreferences
  // obtida do pacote, após a inicialização. É através dela que todas as operações
  // de leitura e escrita são feitas.
  static SharedPreferences? _preferences;

  // Construtor privado. Isso impede que a classe seja instanciada de fora
  // com `SharedPreferencesService()`, forçando o uso do método `init()` para
  // obter a instância.
  SharedPreferencesService._();

  /// Método de inicialização estático e assíncrono.
  ///
  /// É responsável por criar a instância Singleton do serviço e inicializar
  /// o SharedPreferences. Este método DEVE ser chamado antes de qualquer outra
  /// operação de leitura ou escrita (geralmente no `main.dart` da aplicação).
  Future<SharedPreferencesService> init() async {
    // Se a instância já existe, retorna-a imediatamente para não recriá-la.
    if (_instance != null) {
      return _instance!;
    }

    // Cria a instância única da classe usando o construtor privado.
    _instance = SharedPreferencesService._();

    // Aguarda a obtenção da instância do SharedPreferences do dispositivo.
    // Esta é uma operação assíncrona, pois envolve I/O (leitura de disco).
    _preferences = await SharedPreferences.getInstance();

    // Retorna a instância criada e inicializada. O `!` é uma asserção de que
    // `_instance` não é nulo neste ponto.
    return _instance!;
  }

  /// Salva um valor inteiro (`int`) no armazenamento local.
  /// Retorna `true` se a operação for bem-sucedida e `false` caso contrário.
  Future<bool> saveInt(String key, int value) async {
    try {
      // Tenta salvar o valor inteiro associado à chave fornecida.
      bool result = await _preferences!.setInt(key, value);
      return result;
    } catch (erro) {
      // Em caso de erro (ex: _preferences é nulo), imprime uma mensagem de depuração.
      debugPrint("Falha ao salvar inteiro: $erro");
      return false;
    }
  }

  /// Salva um valor de texto (`String`) no armazenamento local.
  /// Retorna `true` se a operação for bem-sucedida e `false` caso contrário.
  Future<bool> saveString(String key, String value) async {
    try {
      bool result = await _preferences!.setString(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar string: $erro");
      return false;
    }
  }

  /// Salva um valor de ponto flutuante (`double`) no armazenamento local.
  /// Retorna `true` se a operação for bem-sucedida e `false` caso contrário.
  Future<bool> saveDouble(String key, double value) async {
    try {
      bool result = await _preferences!.setDouble(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar double: $erro");
      return false;
    }
  }

  /// Salva um valor booleano (`bool`) no armazenamento local.
  /// Retorna `true` se a operação for bem-sucedida e `false` caso contrário.
  Future<bool> saveBool(String key, bool value) async {
    try {
      bool result = await _preferences!.setBool(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar bool: $erro");
      return false;
    }
  }

  /// Salva uma lista de textos (`List<String>`) no armazenamento local.
  /// Retorna `true` se a operação for bem-sucedida e `false` caso contrário.
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      bool result = await _preferences!.setStringList(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar a lista de strings: $erro");
      return false;
    }
  }

  /// Lê um valor inteiro (`int`) do armazenamento local usando a [key] fornecida.
  /// Retorna o valor se encontrado, ou `null` se a chave não existir ou se ocorrer um erro.
  int? getInt(String key) {
    try {
      return _preferences!.getInt(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do inteiro: $erro");
      return null;
    }
  }

  /// Lê um valor de texto (`String`) do armazenamento local.
  /// Retorna o valor se encontrado, ou `null` se a chave não existir ou se ocorrer um erro.
  String? getString(String key) {
    try {
      return _preferences!.getString(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor da string: $erro");
      return null;
    }
  }

  /// Lê um valor booleano (`bool`) do armazenamento local.
  /// Retorna o valor se encontrado, ou `null` se a chave não existir ou se ocorrer um erro.
  bool? getBool(String key) {
    try {
      return _preferences!.getBool(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do booleano: $erro");
      return null;
    }
  }

  /// Lê um valor de ponto flutuante (`double`) do armazenamento local.
  /// Retorna o valor se encontrado, ou `null` se a chave não existir ou se ocorrer um erro.
  double? getDouble(String key) {
    try {
      return _preferences!.getDouble(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do double: $erro");
      return null;
    }
  }

  /// Lê uma lista de textos (`List<String>`) do armazenamento local.
  /// Retorna a lista se encontrada, ou `null` se a chave não existir ou se ocorrer um erro.
  List<String>? getStringList(String key) {
    try {
      return _preferences!.getStringList(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor da lista: $erro");
      return null;
    }
  }

  /// Remove um par chave-valor específico do armazenamento local.
  /// Retorna `true` se a remoção for bem-sucedida e `false` caso contrário.
  Future<bool> remove(String key) async {
    try {
      return await _preferences!.remove(key);
    } catch (erro) {
      debugPrint("Erro ao remover a chave $key: $erro");
      return false;
    }
  }

  /// Limpa TODOS os dados salvos no SharedPreferences pela aplicação.
  /// Esta é uma operação destrutiva.
  /// Retorna `true` se a limpeza for bem-sucedida e `false` caso contrário.
  Future<bool> clearAll() async {
    try {
      return await _preferences!.clear();
    } catch (erro) {
      debugPrint("Erro ao limpar todo o LocalStorage: $erro");
      return false;
    }
  }

  /// Verifica se uma determinada [key] existe no armazenamento local.
  /// Retorna `true` se a chave existir e `false` caso contrário ou se ocorrer um erro.
  bool containsKey(String key) {
    try {
      return _preferences!.containsKey(key);
    } catch (erro) {
      debugPrint("Erro ao verificar chave: $erro");
      return false;
    }
  }

  /// Retorna um conjunto (`Set`) com todas as chaves atualmente salvas no armazenamento.
  /// Retorna um conjunto vazio `{}` em caso de erro.
  Set<String> getKeys() {
    try {
      return _preferences!.getKeys();
    } catch (erro) {
      debugPrint("Erro ao obter chaves: $erro");
      return {};
    }
  }
}
