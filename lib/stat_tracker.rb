require './lib/game_team'
require './lib/team'
require './lib/game'

class StatTracker

  attr_accessor :location

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(location)
    @location = location
    @games = {}
    @teams = {}
    @game_teams = {}
  end

  def self.from_csv(locations)
    locations.map do |location|
      StatTracker.new(location)
    end
  end

  def read_game_stats(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      game = Game.new(row)
      @games[game.game_id] = game
    end
  end

  def read_team_stats(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
      @teams[team.team_id] = team
    end
  end

  def read_game_teams_stats(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row)
      @game_teams[game_team.game_id] = game_team
    end
  end
  # Game Statistics
  def highest_total_score
    high_score = 0
    @games.each_value do |game|
      high = game.away_goals + game.home_goals
      if (game.away_goals + game.home_goals) > high_score
        high_score = game.away_goals + game.home_goals
      end
    end
    high_score
  end

  def lowest_total_score
    low_score = 100
    @games.each_value do |game|
      low = game.away_goals + game.home_goals
      if low < low_score
        low_score = low
      end
    end
    low_score
  end

  def total_games_count
    @games.length.to_f
  end

  def home_wins_count
    home_wins_count = 0.0
    @games.each_value do |game|
      if game.home_goals > game.away_goals
        home_wins_count += 1
      end
    end
    home_wins_count
  end

  def percentage_home_wins
    percentage_home_wins = (home_wins_count / total_games_count) * 100
    percentage_home_wins.round(2)
  end
  # League Statistics


  # Season Statistics


  # Team Statistics



end
