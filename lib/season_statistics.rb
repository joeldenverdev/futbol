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

end
