require './lib/game'

class GameStatistics

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def highest_total_score
    @games.map {|game| game.total_goals}.max
  end

  def lowest_total_score
    @games.map {|game| game.total_goals}.min
  end

  def total_games_count
    @games.length.to_f
  end

  def home_wins_count
    @games.select {|game| game.home_win?}.length.to_f
  end

end
