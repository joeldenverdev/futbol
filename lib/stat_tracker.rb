require './lib/game_team'
require './lib/team'
require './lib/game'

class StatTracker
  attr_accessor :location

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
    # require 'pry'; binding.pry
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
      @game_teams[(game_team.game_id + game_team.hoa)] = game_team
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
  # League Statistics


  # Season Statistics


  # Team Statistics

  def team_info(team_id)
    info = {
      :team_id => @teams[team_id].team_id,
      :franchise_id => @teams[team_id].franchise_id,
      :team_name => @teams[team_id].team_name,
      :abbreviation => @teams[team_id].abbreviation,
      :link => @teams[team_id].link
    }
  end


end
