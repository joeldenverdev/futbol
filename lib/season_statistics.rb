require './lib/game'
require './lib/team'
require './lib/game_team'
require './lib/calculator'

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

 def winningest_coach(season)
   season_games = []
    @games.each do |game|
      if game.season == season
        season_games << game
      end
   end

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

end
