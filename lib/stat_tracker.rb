require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative 'calculator'
require_relative 'game_statistics'
require_relative 'season_statistics'
require_relative 'league_statistics'
require_relative 'team_statistics'

class StatTracker
  include Calculator
  attr_reader :game_stats,
              :team_stats,
              :season_stats,
              :league_stats

  def initialize (games, teams, game_teams)
    @game_stats = GameStatistics.new(games, teams, game_teams)
    @season_stats = SeasonStatistics.new(games, teams, game_teams)
    @team_stats = TeamStatistics.new(games, teams, game_teams)
    @league_stats = LeagueStatistics.new(games, teams, game_teams)
  end

  def self.from_csv(locations)
    games = []
    CSV.foreach(locations[:games], headers: true, header_converters: :symbol) do |row|
      game = Game.new(row)
      games << game
    end
    teams = []
    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
      teams << team
    end
    game_teams = []
    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row)
      game_teams << game_team
    end

    stat_tracker = StatTracker.new(games, teams, game_teams)
  end

   # Game Statistics
  def highest_total_score
    @game_stats.highest_total_score
  end

  def lowest_total_score
    @game_stats.lowest_total_score
  end

  def percentage_home_wins
    @game_stats.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_stats.percentage_visitor_wins
  end

  def percentage_ties
    @game_stats.percentage_ties
  end

  def count_of_games_by_season
    @game_stats.count_of_games_by_season
  end

  def average_goals_per_game
    @game_stats.average_goals_per_game
  end

  def average_goals_by_season
    @game_stats.average_goals_by_season
  end

  # League Statistics

  def count_of_teams
    @league_stats.count_of_teams
  end

  def best_offense
    @league_stats.best_offense
    id = @game_teams.max_by do |team|
      average_goals_per_game_by_team(team.team_id)
    end.team_id
    team_name_by_id(id)
  end

  def worst_offense
    id = @game_teams.min_by do |team|
      average_goals_per_game_by_team(team.team_id)
    end.team_id
    team_name_by_id(id)
  end

  def games_away(team_id)
    games = games_by_team(team_id)
    away = []
    games.each do |game|
      if game.hoa == "away"
        away << game
      end
    end
    away
  end

# Season Statistics

   def season_games(season)
    @games.find_all do |game|
      game.season == season
    end
  end

  def winningest_coach(season)
    @season_stats.winningest_coach(season)
    filtered_game_teams = []
    @game_teams.each do |game_team|
      season_games(season).each do |game|
        if game.game_id == game_team.game_id
          filtered_game_teams << game_team
        end
      end
    end

    coach_win_count = Hash.new(0)
    filtered_game_teams.each do |game_team|
      if game_team.result == "WIN"
        coach_win_count[game_team.head_coach] += 1
      end
    end

    coach_total_game_count = Hash.new(0)
    filtered_game_teams.each do |game_team|
      coach_total_game_count[game_team.head_coach] += 1
    end

    winning_percent = Hash.new(0)
    coach_total_game_count.each_key do |key|
      winning_percent[key] = coach_win_count[key] / coach_total_game_count[key].to_f * 100
    end

    winning_coach = winning_percent.max_by { |key, value| value }[0]
  end

  def worst_coach(season)
    filtered_game_teams = []
    @game_teams.each do |game_team|
      season_games(season).each do |game|
        if game.game_id == game_team.game_id
          filtered_game_teams << game_team
        end
      end
    end

    coach_win_count = Hash.new(0)
    filtered_game_teams.each do |game_team|
      if game_team.result == "WIN"
        coach_win_count[game_team.head_coach] += 1
      end
    end

    coach_total_game_count = Hash.new(0)
    filtered_game_teams.each do |game_team|
      coach_total_game_count[game_team.head_coach] += 1
    end

    losing_percent = Hash.new(0)
    coach_total_game_count.each_key do |key|
      losing_percent[key] = coach_win_count[key] / coach_total_game_count[key].to_f * 100
    end
    losing_coach = losing_percent.min_by { |key, value| value }[0]
  end


  def most_accurate_team(season)
    filtered_teams = []
    @teams.each do |team|
      @game_teams.each do |game_team|
        season_games(season).each do |game|
          if game_team.team_id == team.team_id && game.game_id == game_team.game_id
            filtered_teams << team
          end
        end
      end
    end

    goal_count = Hash.new(0)
    filtered_teams.each do |game_team|
      goal_count[game_team.team_id] += 1
    end

    shots_count = Hash.new(0)
    filtered_teams.each do |game_team|
      shots_count[game_team.team_id] += 1
    end

    best_ratio = Hash.new(0)
    filtered_teams.each do |game_team|
      goal_count.each_value do |goal|
        shots_count.each_value do |shot|
          if goal >= shot
            best_ratio[game_team.team_id] += 1
          end
        end
      end
    end

    best_team_id = best_ratio.max_by { |key, value| value }[0]

    team_name = @teams.find do |team|
      team.team_id == best_team_id
    end
    team_name.team_name
  end

  def least_accurate_team(season)
    filtered_teams = []
    @teams.each do |team|
      @game_teams.each do |game_team|
        season_games(season).each do |game|
          if game_team.team_id == team.team_id && game.game_id == game_team.game_id
            filtered_teams << team
          end
        end
      end
    end

    goal_count = Hash.new(0)
    filtered_teams.each do |game_team|
      goal_count[game_team.team_id] += 1
    end

    shots_count = Hash.new(0)
    filtered_teams.each do |game_team|
      shots_count[game_team.team_id] += 1
    end

    worst_ratio = Hash.new(0)
    filtered_teams.each do |game_team|
      goal_count.each_value do |goal|
        shots_count.each_value do |shot|
          if goal <= shot
            worst_ratio[game_team.team_id] += 1
          end
        end
      end
    end

    worst_team_id = worst_ratio.min_by { |key, value| value }[0]

    team_name = @teams.find do |team|
      team.team_id == worst_team_id
    end
    team_name.team_name
  end

  def most_tackles(season)
    filtered_game_teams = []
    @game_teams.each do |game_team|
      season_games(season).each do |game|
        if game.game_id == game_team.game_id
          filtered_game_teams << game_team
        end
      end
    end

    total_team_tackles = Hash.new(0)
    filtered_game_teams.each do |game_team|
      total_team_tackles[game_team.team_id] += game_team.tackles
    end

    team_id_tackles = total_team_tackles.max_by { |key, value| value }[0]

    team_name = @teams.find do |team|
      team.team_id == team_id_tackles
    end

    team_name.team_name
  end

  def fewest_tackles(season)
    filtered_game_teams = []
    @game_teams.each do |game_team|
      season_games(season).each do |game|
        if game.game_id == game_team.game_id
          filtered_game_teams << game_team
        end
      end
    end

    total_team_tackles = Hash.new(0)
    filtered_game_teams.each do |game_team|
      total_team_tackles[game_team.team_id] += game_team.tackles
    end

    team_id_tackles = total_team_tackles.min_by { |key, value| value }[0]

    team_name = @teams.find do |team|
      team.team_id == team_id_tackles
    end
    team_name.team_name
  end

  def average_away_score(team_id)
    games = games_away(team_id)
    away_scores = games_away(team_id).map do |game|
      game.goals
    end
    avg = away_scores.sum.to_f / games.length.to_f
    avg.round(1)
  end

  def highest_scoring_visitor
    id = @game_teams.max_by do |game|
      average_away_score(game.team_id)
    end.team_id
    @teams.find do |team|
      id == team.team_id
    end.team_name
  end

  def games_home(team_id)
    games = games_by_team(team_id)
    home = []
    games.each do |game|
      if game.hoa == "home"
        home << game
      end
    end
    home
  end

  def average_home_score(team_id)
    games = games_home(team_id)
    home_scores = games_home(team_id).map do |game|
      game.goals
    end
    avg = home_scores.sum.to_f / games.length.to_f
    avg.round(1)
  end

  def highest_scoring_home_team
    id = @game_teams.max_by do |game|
      average_home_score(game.team_id)
    end.team_id

    @teams.find do |team|
      id == team.team_id
    end.team_name
  end

  def lowest_scoring_visitor
    id = @game_teams.min_by do |game|
      average_away_score(game.team_id)
    end.team_id

    @teams.find do |team|
      id == team.team_id
    end.team_name
  end

  def lowest_scoring_home_team
    id = @game_teams.min_by do |game|
      average_home_score(game.team_id)
    end.team_id

    @teams.find do |team|
      id == team.team_id
    end.team_name

  end

  # Team Statistics

  def team_info(team_id)
    @team_stats.team_info(team_id)
  end

  def best_season(team_id)
    @team_stats.best_season(team_id)
  end

  def worst_season(team_id)
    @team_stats.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team_stats.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team_stats.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team_stats.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team_stats.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team_stats.rival(team_id)
  end
end
