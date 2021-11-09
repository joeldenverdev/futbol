require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative 'calculator'

class LeagueStatistics
  include Calculator

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def count_of_teams
    @teams.length
  end

  def best_offense
    id = @game_teams.max_by do |team|
      average_goals_per_game_by_team(team.team_id)
    end.team_id
    team_name_by_id(id)
  end

  def team_name_by_id(team_id)
    @teams.find do |team|
      team_id == team.team_id
    end.team_name
  end

  def average_goals_per_game_by_team(team_id)
    avg = total_goals_by_team(team_id).to_f / games_by_team(team_id).length.to_f
    avg.round(2)
  end

  def total_goals_by_team(team_id)
    goals = []
    games_by_team(team_id).each do |game|
      goals << game.goals
    end
    goals.sum
  end

  def games_by_team(team_id)
    @game_teams.select do |game|
      game.team_id == team_id
    end
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
end
