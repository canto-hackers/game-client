import 'package:canto_cards_game/game/game_details_model.dart';
import 'package:canto_cards_game/game/game_model.dart';
import 'package:canto_cards_game/player/player_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbOps {
  final supabase = Supabase.instance.client;

  Future<List<Game>> getNewGames() async {
    final List<dynamic> data = await supabase.from('games').select('*').match({'status': 'new'});
    if (data.isEmpty) {
      // handle empty data
      return [];
    }
    List<Game> games = data.map((e) => Game.fromJson(e)).toList();
    return games;
  }

  Future<Game> insertGame(String name, int hostId) async {
    final List<Map<String, dynamic>> data = await supabase.from('games').insert([
      {'name': name, 'hostId': hostId},
    ]).select();
    return Game.fromJson(data.first);
  }

  Future<Game> updateGame(Game game) async {
    final List<Map<String, dynamic>> data = await supabase.from('games').update(game.toJson()).eq('id', game.id).select();

    return Game.fromJson(data.first);
  }

  Future<Player> getPlayer(int id) async {
    final List<dynamic> data = await supabase.from('players').select('*').match({'id': id});
    if (data.isEmpty) {
      // handle empty data
      // return null;
    }
    Player player = Player.fromJson(data.first);
    return player;
  }

  Future<GameDetails> insertGameDetails(int gameId) async {
    final List<Map<String, dynamic>> data = await supabase.from('game_details').insert([
      {'gameId': gameId},
    ]).select();
    return GameDetails.fromJson(data.first);
  }

  Future<GameDetails> updateGameDetails(GameDetails gameDetails) async {
    final List<Map<String, dynamic>> data = await supabase.from('game_details').update(gameDetails.toJson()).eq('id', gameDetails.id).select();

    return GameDetails.fromJson(data.first);
  }

  Future<Game> updateGameStatus(Game game) async {
    final List<Map<String, dynamic>> data = await supabase.from('games').update({'status': game.status}).eq('id', game.id).select();

    return Game.fromJson(data.first);
  }
}
