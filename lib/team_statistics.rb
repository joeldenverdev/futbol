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

  # def best_season(team_id)
  #   total_by_season = Hash.new(0)
  #   wins_by_season = Hash.new(0)
  #   percent_by_season = Hash.new(0)
  #
  #   games = @game_teams.select { |game_team| game_team.team_id.to_s == team_id }
  #   game_ids = games.map { |game|(game.game_id.to_s + game.hoa) }
  #   won_games = @game_teams.select do |game_team|
  #     game_team.team_id.to_s == team_id && game_team.result == "WIN"
  #   end
  #   won_ids = won_games.map { |won_game| won_game.game_id.to_s }
  #
  #   game_ids.each do |id|
  #     @games.each do |game|
  #       if game.game_id == id.slice(0..9).to_i
  #         total_by_season[game.season] += 1
  #       end
  #     end
  #   end
  #
  #   won_ids.each do |id|
  #     @games.each do |game|
  #       if game.game_id.to_s == id
  #         wins_by_season[game.season] += 1
  #       end
  #     end
  #   end
  #
  #   total_by_season.each_key { |key|percent_by_season[key] = percentage(wins_by_season[key], total_by_season[key]) }
  #   max_season = percent_by_season.max_by { |key,value| value }[0]
  # end

  def total_by_season(game_ids)
    total_by_season = Hash.new(0)
    game_ids.each do |id|
      @games.each do |game|
        if game.game_id == id.slice(0..9)
          total_by_season[game.season] += 1
        end
      end
    end
    total_by_season
  end

  def wins_by_season(game_ids)
    wins_by_season = Hash.new(0)
    game_ids.each do |id|
      @games.each do |game|
        if game.game_id == id
          wins_by_season[game.season] += 1
        end
      end
    end
    wins_by_season
  end

  def games_by_team(game_ids, team_id)
    games_by_team = Hash.new(0)
    game_ids.each do |id|
      @game_teams.each do |game|
        if game.game_id == id.slice(0..9) && game.team_id != team_id
          games_by_team[game.team_id] += 1
        end
      end
    end
    games_by_team
  end

  def wins_by_team(game_ids, team_id)
    wins_by_team = Hash.new(0)
    game_ids.each do |id|
      @game_teams.each do |game|
        if game.game_id == id.slice(0..9) && game.team_id != team_id && game.result == "WIN"
          wins_by_team[game.team_id] += 1
        end
      end
    end
    wins_by_team
  end

  def team_game_ids(team_id)
    games = @game_teams.select { |game_team| game_team.team_id == team_id }
    games.map { |game| (game.game_id + game.hoa) }
  end

  def won_game_ids(team_id)
    won_games = @game_teams.select { |game_team| game_team.team_id == team_id && game_team.result == "WIN" }
    won_games.map { |won_game| won_game.game_id }
  end

  def team_info(team_id)
    team = @teams.find { |team| team.team_id.to_s == team_id }
    info = {
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end

  def best_season(team_id)
    percent_by_season = Hash.new(0)
    games_by_season = total_by_season(team_game_ids(team_id))
    wins_by_season = wins_by_season(won_game_ids(team_id))
    games_by_season.each_key do |key|
      percent_by_season[key] = percentage(wins_by_season[key], games_by_season[key])
    end
    max_season = percent_by_season.max_by { |key,value| value }[0]
  end

  def worst_season(team_id)
    percent_by_season = Hash.new(0)
    games_by_season = total_by_season(team_game_ids(team_id))
    wins_by_season = wins_by_season(won_game_ids(team_id))
    games_by_season.each_key do |key|
      percent_by_season[key] = percentage(wins_by_season[key], games_by_season[key])
    end
    max_season = percent_by_season.min_by { |key,value| value }[0]
  end

  def average_win_percentage(team_id)
    total_games = @game_teams.select { |game_team| game_team.team_id == team_id }
    total_wins = total_games.select { |game| game.result == "WIN" }
    percentage(total_wins.count, total_games.count)
  end

  def most_goals_scored(team_id)
    total_games = @game_teams.select { |game_team| game_team.team_id == team_id }
    total_games.max_by { |game| game.goals }.goals
  end

  def fewest_goals_scored(team_id)
    total_games = @game_teams.select { |game_team| game_team.team_id == team_id }
    total_games.min_by { |game| game.goals }.goals
  end

  def favorite_opponent(team_id)
    percent_by_team = Hash.new(0)
    games_by_team = games_by_team(team_game_ids(team_id), team_id)
    wins_by_team = wins_by_team(team_game_ids(team_id), team_id)
    games_by_team.each_key do |key|
      percent_by_team[key] = percentage(wins_by_team[key], games_by_team[key])
    end
    fav = percent_by_team.min_by { |key, value| value }[0]
    @teams.select { |team| team.team_id == fav }.first.team_name
  end

  def rival(team_id)
    percent_by_team = Hash.new(0)
    games_by_team = games_by_team(team_game_ids(team_id), team_id)
    wins_by_team = wins_by_team(team_game_ids(team_id), team_id)
    games_by_team.each_key do |key|
      percent_by_team[key] = percentage(wins_by_team[key], games_by_team[key])
    end
    fav = percent_by_team.max_by { |key, value| value }[0]
    @teams.select { |team| team.team_id == fav }.first.team_name
  end

end
