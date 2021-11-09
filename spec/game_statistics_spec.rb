require './lib/game_statistics'
require './lib/stat_tracker'

RSpec.describe GameStatistics do
  before(:each) do

    game_path = './data/games_tester.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams_tester.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)

    @game_stats = @stat_tracker.game_stats
  end

  describe '#initialize' do
    it 'exists' do
      expect(@game_stats).to be_an_instance_of GameStatistics
    end

    it 'has access to CSVs in array format' do
      expect(@game_stats.games).to be_instance_of Array
      expect(@game_stats.teams).to be_instance_of Array
      expect(@game_stats.game_teams).to be_instance_of Array
    end

    it 'is intialized as StatTracker class variable' do
      expect(@stat_tracker.game_stats).to be_an_instance_of GameStatistics
    end
  end

  describe '#highest_total_score' do
    it 'returns an integer' do
      expect(@game_stats.highest_total_score).to be_an_instance_of Integer
    end

    it 'returns highest total of winning and losing team score by game' do
      expect(@game_stats.highest_total_score).to eq 9
    end
  end

  describe '#lowest_total_score' do
    it 'returns an integer' do
      expect(@game_stats.lowest_total_score).to be_an_instance_of Integer
    end

    it 'returns lowest total of winning and losing team score by game' do
      expect(@game_stats.lowest_total_score).to eq 1
    end
  end

  describe '#total_games_count' do
    it 'returns the total number of games' do
      expect(@game_stats.total_games_count).to be_an_instance_of Float

      expect(@game_stats.total_games_count).to eq 500.0
    end
  end

  describe '#home_wins_count' do
    it 'counts the number of times home team outscored away team' do
      expect(@game_stats.home_wins_count).to be_an_instance_of Float

      expect(@game_stats.home_wins_count).to eq 232.0
    end
  end

  describe '#percentage_home_wins' do
    it 'returns a float' do
      expect(@game_stats.percentage_home_wins).to be_an_instance_of Float
    end

    it 'returns percentage of games won by the home team' do
      expected = @game_stats.percentage_home_wins

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  describe '#visitor_wins_count' do
    it 'counts the numbers of times away team outscored home team' do
      expect(@game_stats.visitor_wins_count).to be_an_instance_of Float

      expect(@game_stats.visitor_wins_count).to eq 195.0
    end
  end

  describe '#percentage_visitor_wins' do
    it 'returns a float' do
      expect(@game_stats.percentage_visitor_wins).to be_an_instance_of Float

      expected = @game_stats.percentage_visitor_wins

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  describe '#tied_games_count' do
    it 'returns a float' do
      expect(@game_stats.tied_games_count).to be_an_instance_of Float

      expect(@game_stats.tied_games_count).to eq 73.0
    end
  end

  describe '#percentage_ties' do
    it 'returns the percentage of game where the scores were equal' do
      expect(@game_stats.percentage_ties).to be_an_instance_of Float

      expected = @game_stats.percentage_ties

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  describe '#total_goals' do
    it 'counts the total number of away_goals and home_goals' do
      expect(@game_stats.total_goals).to be_an_instance_of Integer

      expect(@game_stats.total_goals).to eq 2088
    end
  end

  describe '#average_goals_per_game' do
    it 'divides the total number of goals by the total number of games' do
      expect(@game_stats.average_goals_per_game).to be_an_instance_of Float

      expect(@game_stats.average_goals_per_game).to eq 4.18
    end
  end

  describe '#percentage calculator methods' do
    it 'equals 1' do
      wins = @game_stats.percentage_visitor_wins

      losses = @game_stats.percentage_visitor_wins

      ties = @game_stats.percentage_ties

      total = wins + losses + ties

      expect(total.round).to eq 1
      expect(total).to be > 0.9
    end
  end

  describe '#count_of_games_by_season' do
    it 'returns array with season id as key and count as value' do
      @game_stats.count_of_games_by_season
      expect(@game_stats.count_of_games_by_season).to be_an_instance_of Hash
    end

    it 'has helper get_season_ids' do
      expect(@game_stats.get_season_ids).to be_an_instance_of Array

      expect(@game_stats.get_season_ids).to include("20132014")
      expect(@game_stats.get_season_ids).to include("20162017")
      expect(@game_stats.get_season_ids).to include("20172018")
    end

    it 'has helper method filter_by_season' do
      expect(@game_stats.filter_by_season("20122013")).to be_instance_of Array
    end
  end

  describe '#average_goals_by_season' do
    it 'returns hash with season id as key and float of average number of goals per game as value' do
      expect(@game_stats.average_goals_by_season).to be_an_instance_of Hash
    end

    it 'has season numbers as keys' do
      expect(@game_stats.average_goals_by_season.keys.include?("20122013")).to be_truthy

      expect(@game_stats.average_goals_by_season.keys.include?("20162017")).to be_truthy

      expect(@game_stats.average_goals_by_season.keys.include?("20172018")).to be_truthy

      first_season_goals = @game_stats.average_goals_by_season.values[0]

      expect(first_season_goals).to eq(first_season_goals.round(2))
    end
  end

end
