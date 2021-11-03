require 'csv'
require './lib/stat_tracker'
require './lib/game_team'
require './lib/game'
require './lib/team'
require './runner'


# Game Statistics Tests

RSpec.describe StatTracker do
  before(:each) do
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
    @stat_tracker[0].read_game_stats(@game_path)
    @stat_tracker[0].read_team_stats(@team_path)
    @stat_tracker[0].read_game_teams_stats(@game_teams_path)
  end

  xdescribe '#initialize' do
    it 'is an instance of StatTracker' do
      expect(@stat_tracker).to be_an_instance_of Array
    end

    it 'can read games.csv' do
      expect(@stat_tracker[0].games).to be_an_instance_of(Hash)
    end

    it 'can read teams.csv' do
      expect(@stat_tracker[0].teams).to be_an_instance_of(Hash)
    end

    it 'can read game_teams.csv' do
      expect(@stat_tracker[0].game_teams).to be_an_instance_of(Hash)
    end
  end

  xdescribe '#highest_total_score' do
    it 'returns an integer' do
      expect(@stat_tracker[0].highest_total_score).to be_an_instance_of Integer
    end

    it 'returns highest total of winning and losing team score by game' do
      expect(@stat_tracker[0].highest_total_score).to eq 11
    end
  end

  xdescribe '#lowest_total_score' do
    it 'returns an integer' do
      expect(@stat_tracker[0].lowest_total_score).to be_an_instance_of Integer
    end

    it 'returns lowest total of winning and losing team score by game' do
      expect(@stat_tracker[0].lowest_total_score).to eq 0
    end
  end

  describe '#total_games_count' do
    it 'returns the total number of games' do
      expect(@stat_tracker[0].total_games_count).to be_an_instance_of Float

      expect(@stat_tracker[0].total_games_count).to eq 7441.0
    end
  end

  describe '#home_wins_count' do
    it 'counts the number of times home team outscored away team' do
      expect(@stat_tracker[0].home_wins_count).to be_an_instance_of Float

      expect(@stat_tracker[0].home_wins_count).to eq 3237.0
    end
  end

  describe '#percentage_home_wins' do
    it 'returns a float' do
      expect(@stat_tracker[0].percentage_home_wins).to be_an_instance_of Float
    end

    it 'percentage of games won by the home team' do
      expect(@stat_tracker[0].percentage_home_wins).to eq 43.50
    end
  end
end




# League Statistics Tests


# Season Statistics Tests


# Team Statistics Tests
