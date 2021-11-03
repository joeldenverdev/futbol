require './lib/stat_tracker'
require 'csv'
require './lib/game_team'
require './lib/game'
require './lib/team'
require './runner'
require 'rspec'


# Game Statistics Tests


# League Statistics Tests


# Season Statistics Tests


# Team Statistics Tests
describe StatTracker do
  before(:each) do
    game_path = './data/games_test.csv'
    team_path = './data/teams_test.csv'
    game_teams_path = './data/game_teams_test.csv'
    @games = {}
    @teams = {}
    @game_teams = {}
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    stat_tracker = StatTracker.from_csv(locations)
    stat_tracker[0].read_game_stats(game_path)
    stat_tracker[0].read_team_stats(team_path)
    stat_tracker[0].read_game_teams_stats(game_teams_path)
    require 'pry'; binding.pry

  end

  describe '#team_info' do
    it 'returns team_id, franchise_id, team_name, abbr., and link' do
      expected = {
        team_id => 27,
        franchise_id => 28,
        team_name => "San Jose Earthquakes",
        abbreviation => "SJ",
        link => "/api/v1/teams/27"
      }
      require 'pry'; binding.pry
      expect(stat_tracker[0].team_info).to eq(expected)
    end
  end

  describe '#best_season' do
    xit 'returns the season with the highest win percentage for a team' do

    end
  end

  describe '#worst_season' do
    xit 'returns the season with the lowest win percentage for a team' do

    end
  end

  describe '#average_win_percentage' do
    xit 'returns the average win percentage of all games for a team' do

    end
  end

  describe '#most_goals_scored' do
    xit 'returns the highest nuber of goals a particular team has scored in a single game' do

    end
  end

  describe '#fewest_goals_scored' do
    it 'returns the lowest numer of goals a particular team has scored in a single game' do

    end
  end

  describe '#favorite_opponent' do
    xit 'returns the name of the opponent that has the lowest win percentage against the given team' do

    end
  end

  describe '#rival' do
    xit 'returns the name of the opponent that has the highest win percentage against the given team' do

    end
  end
end
