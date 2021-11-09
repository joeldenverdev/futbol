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

end
