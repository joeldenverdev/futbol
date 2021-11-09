require_relative 'game'
require_relative 'calculator'

class GameStatistics
  include Calculator

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

  def percentage_home_wins
    percentage(home_wins_count, total_games_count)
  end

  def visitor_wins_count
    @games.select {|game| game.visitor_win?}.length.to_f
  end

  def percentage_visitor_wins
    percentage(visitor_wins_count, total_games_count)
  end

  def tied_games_count
    @games.select {|game| game.tie_game?}.length.to_f
  end

  def percentage_ties
    percentage(tied_games_count, total_games_count)
  end

  def total_goals
    @games.map {|game| game.total_goals}.sum
  end

  def average_goals_per_game
    all_total_goals = @games.map {|game| game.total_goals}
    average(all_total_goals)
  end

  def get_season_ids
    @games.map do |game|
      game.season
    end
  end

  def filter_by_season(season_id)
    #create array of all items with season_id
    filtered_seasons = []

    @games.each do |game|
      if season_id == game.season
        filtered_seasons << game
      end
    end
    filtered_seasons
  end

  def count_of_games_by_season
    season_game_count = {}

    get_season_ids.uniq.each do |season_id|
      season_game_count[season_id] = filter_by_season(season_id).length.to_f
    end
    season_game_count
  end

  def average_goals_by_season
    average_goals_by_season = {}
    get_season_ids.uniq.each do |season_id|
      season_goal_count = 0

      season_games = filter_by_season(season_id)

      season_games.each do |game|
          season_goal_count += game.total_goals
      end

      average_goals = season_goal_count.to_f / season_games.length.to_f

      average_goals_by_season[season_id] = average_goals.round(2)
    end
    average_goals_by_season
  end

end
