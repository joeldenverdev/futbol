require './lib/game'
require './lib/team'
require './lib/game_team'
require './lib/calculator'

class TeamStatistics
  include Calculator

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def team_info(team_id)
    team = @teams.find { |team| team.team_id.to_s == team_id }

    info = {
      "team_id" => team.team_id.to_s,
      "franchise_id" => team.franchise_id.to_s,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def best_season(team_id)
    total_by_season = Hash.new(0)
    wins_by_season = Hash.new(0)
    percent_by_season = Hash.new(0)

    games = @game_teams.select { |game_team| game_team.team_id.to_s == team_id }
    game_ids = games.map { |game|(game.game_id.to_s + game.hoa) }
    won_games = @game_teams.select do |game_team|
      game_team.team_id.to_s == team_id && game_team.result == "WIN"
    end
    won_ids = won_games.map { |won_game| won_game.game_id.to_s }

    game_ids.each do |id|
      @games.each do |game|
        if game.game_id == id.slice(0..9).to_i
          total_by_season[game.season] += 1
        end
      end
    end

    won_ids.each do |id|
      @games.each do |game|
        if game.game_id.to_s == id
          wins_by_season[game.season] += 1
        end
      end
    end

    total_by_season.each_key { |key|percent_by_season[key] = percentage(wins_by_season[key], total_by_season[key]) }
    max_season = percent_by_season.max_by { |key,value| value }[0]
  end

end
