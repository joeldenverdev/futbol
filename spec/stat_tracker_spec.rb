require_relative './lib/stat_tracker'
require 'csv'
require_relative './lib/game_team'
require_relative './lib/game'
require_relative './lib/team'
require_relative './runner'


# Game Statistics Tests


# League Statistics Tests


# Season Statistics Tests


# Team Statistics Tests
describe StatTracker do
  before(:each) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    game_1 = Game.new()
  end

  describe '#team_info' do
    it 'returns team_id, franchise_id, team_name, abbr., and link' do
    end
  end

  describe '#best_season' do
    it 'returns the season with the highest win percentage for a team' do

    end
  end

  describe '#worst_season' do
    it 'returns the season with the lowest win percentage for a team' do

    end
  end

  describe '#average_win_percentage' do
    it 'returns the average win percentage of all games for a team' do

    end
  end

  describe '#most_goals_scored' do
    it 'returns the highest nuber of goals a particular team has scored in a single game' do

    end
  end

  describe '#fewest_goals_scored' do
    it 'returns the lowest numer of goals a particular team has scored in a single game' do

    end
  end

  describe '#favorite_opponent' do
    it 'returns the name of the opponent that has the lowest win percentage against the given team' do

    end
  end

  describe '#rival' do
    it 'returns the name of the opponent that has the highest win percentage against the given team' do

    end
  end
end
