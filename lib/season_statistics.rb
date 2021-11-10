require_relative 'game'
require_relative 'team'
require_relative 'game_team'
require_relative 'calculator'

class SeasonStatistics
  include Calculator

  attr_reader :games,
              :teams,
              :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def season_games(season)
   @games.find_all do |game|
     game.season == season
   end
 end

 def filtered_game_teams(season)
  filtered_game_teams = []
   @game_teams.each do |game_team|
     season_games(season).each do |game|
       if game.game_id == game_team.game_id
         filtered_game_teams << game_team
       end
     end
   end
   filtered_game_teams
end

  def filtered_teams(season)
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
    filtered_teams
  end

  def best_ratio(select_teams, goal_count, shots_count)
    best_ratio = Hash.new(0)
    ratio = Hash.new(0)
    select_teams.each do |game_team|
      goal_count.each_value do |goal|
        shots_count.each_value do |shot|
          ratio[game_team.team_id] = goal_count[game_team.team_id] / shots_count[game_team.team_id].to_f * 100
        end
      end
    end
    best_ratio
  end

  def worst_ratio(select_teams, goal_count, shots_count)
    worst_ratio = Hash.new(0)
    ratio = Hash.new(0)
    select_teams.each do |game_team|
      goal_count.each_value do |goal|
        shots_count.each_value do |shot|
         ratio[game_team.team_id] = goal_count[game_team.team_id] / shots_count[game_team.team_id].to_f * 100
        end
      end
    end
    worst_ratio
  end

 def winningest_coach(season)
   select_game_teams = filtered_game_teams(season)
   coach_win_count = Hash.new(0)
   select_game_teams.each do |game_team|
     if game_team.result == "WIN"
       coach_win_count[game_team.head_coach] += 1
     end
   end
   coach_total_game_count = Hash.new(0)
   select_game_teams.each { |game_team| coach_total_game_count[game_team.head_coach] += 1 }
   winning_percent = Hash.new(0)
   coach_total_game_count.each_key { |key| winning_percent[key] = coach_win_count[key] / coach_total_game_count[key].to_f * 100 }
   winning_coach = winning_percent.max_by { |key, value| value }[0]
 end

 def worst_coach(season)
   select_game_teams = filtered_game_teams(season)
   coach_win_count = Hash.new(0)
   select_game_teams.each do |game_team|
     if game_team.result == "WIN"
       coach_win_count[game_team.head_coach] += 1
     end
   end
   coach_total_game_count = Hash.new(0)
   select_game_teams.each { |game_team| coach_total_game_count[game_team.head_coach] += 1 }
   losing_percent = Hash.new(0)
   coach_total_game_count.each_key { |key| losing_percent[key] = coach_win_count[key] / coach_total_game_count[key].to_f * 100 }
   losing_coach = losing_percent.min_by { |key, value| value }[0]
   require "pry"; binding.pry
 end

 def most_accurate_team(season)
   select_teams = filtered_teams(season)
   goal_count = Hash.new(0)
   select_teams.each do |game_team|
     @games.each do |game|
         if game_team.team_id == game.away_team_id.to_s
           goal_count[game_team.team_id] += game.away_goals
         elsif game_team.team_id == game.home_team_id.to_s
           goal_count[game_team.team_id] += game.home_goals
        end
      end
    end
   shots_count = Hash.new(0)
   select_teams.each { |game_team| shots_count[game_team.team_id] += 1 }
   highest_ratio = best_ratio(select_teams, goal_count, shots_count)
   best_team_id = highest_ratio.max_by { |key, value| value }[0]
   @teams.find { |team| team.team_id == best_team_id }.team_name
 end

 def least_accurate_team(season)
   select_game_teams = filtered_game_teams(season)
   select_teams = filtered_teams(season)
   goal_count = Hash.new(0)
   teams = @teams.map do |team|
     team.team_id
   end
   teams.each do |game_team|
     @games.each do |game|
         if game_team.team_id == game.away_team_id.to_s
           goal_count[game_team.team_id] += game.away_goals
         elsif game_team.team_id == game.home_team_id.to_s
           goal_count[game_team.team_id] += game.home_goals
        end
      end
    end
   shots_count = Hash.new(0)
   teams.each do |team|
     select_game_teams.each do |game|
       if game.team_id == team
         shots_count[team.team_id] += game.shots
       end
    end
  end
   lowest_ratio = worst_ratio(select_teams, goal_count, shots_count)
   worst_team_id = lowest_ratio.min_by { |key, value| value }[0]
   @teams.find { |team| team.team_id == worst_team_id}.team_name
 end

 def most_tackles(season)
   select_game_teams = filtered_game_teams(season)
   total_team_tackles = Hash.new(0)
   select_game_teams.each { |game_team| total_team_tackles[game_team.team_id] += game_team.tackles }
   team_id_tackles = total_team_tackles.max_by { |key, value| value }[0]
   team_name = @teams.find { |team| team.team_id == team_id_tackles }.team_name
 end

 def fewest_tackles(season)
   select_game_teams = filtered_game_teams(season)
   total_team_tackles = Hash.new(0)
   select_game_teams.each { |game_team| total_team_tackles[game_team.team_id] += game_team.tackles }
   team_id_tackles = total_team_tackles.min_by { |key, value| value }[0]
   team_name = @teams.find { |team| team.team_id == team_id_tackles }.team_name
end
end
