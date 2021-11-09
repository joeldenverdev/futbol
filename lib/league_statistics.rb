require './lib/game'
require './lib/team'
require './lib/game_team'
require './lib/calculator'

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

    @teams.find do |team|
      id == team.team_id
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

end
