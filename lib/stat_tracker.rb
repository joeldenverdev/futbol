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
    @min_team = 0
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

  def best_season(team_id)
    game_ids = []
    won_game_ids = []
    total_by_season = Hash.new(0)
    wins_by_season = Hash.new(0)
    percent_by_season = Hash.new(0)

    @game_teams.each do |a, b|
      if b.team_id == team_id
        game_ids << a
      end
    end

    game_ids.each do |id|
      @game_teams.each_value do |a|
        if id == a.game_id + a.hoa
          if a.result == "WIN"
            won_game_ids << id.slice(0..9)
          end
        end
      end
    end

    game_ids.each do |id|
      @games.each_value do |a|
        if a.game_id.to_s == id.slice(0..9)
          total_by_season[a.season] += 1
        end
      end
    end

    won_game_ids.each do |id|
      @games.each_value do |a|
        if a.game_id.to_s == id
          wins_by_season[a.season] += 1
        end
      end
    end

    total_by_season.each_key do |a|
      percent_by_season[a] = wins_by_season[a] * 100 / total_by_season[a].to_f
    end
    
    max_season = percent_by_season.max_by { |key,value| value }[0]

  end


end
