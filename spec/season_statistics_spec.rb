require './lib/season_statistics'
require './lib/stat_tracker'

RSpec.describe SeasonStatistics do
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

    @season_stats = @stat_tracker.season_stats
  end

  describe '#initialize' do
    it 'exists' do
      expect(@season_stats).to be_instance_of SeasonStatistics
    end

    it 'is instantiated with StatTracker' do
      expect(@stat_tracker.season_stats).to be_instance_of SeasonStatistics
    end
  end

  describe '#season_games' do
    it 'finds all the matching games for a given season' do
      expect(@season_stats.season_games("20122013").map { |game| game.game_id }).to eq([])
    end
  end

  describe '#filtered_game_teams' do
    it 'returns an Array' do
      expect(@season_stats.filtered_game_teams("20122013")).to be_an(Array)
    end
    it 'filters by game_id to ensure they match in both game and game file' do
      expect(@season_stats.filtered_game_teams("20122013").map { |game| game.game_id }).to eq(["2012030221", "2012030221", "2012030222", "2012030222", "2012030223", "2012030223", "2012030224", "2...", "2012020108", "2012020598", "2012020598", "2012020298", "2012020298", "2012020495", "2012020495"])
    end
  end
  describe '#filtered_teams' do
    it 'returns an Array' do
      expect(@season_stats.filtered_game_teams("20122013")).to be_an(Array)
    end
    it 'filters by game_id to ensure they match in both game and game file' do
      expect(@season_stats.filtered_game_teams("20122013").map { |game| game.game_id }).to eq([])
  end

  describe '#best_ratio' do
    it 'gives a hash of team id' do
    expected = {}
    expect(season_stats.best_ratio).to eq(expected)
    end
  end

  describe '#worst_ratio' do
    it 'gives a hash 'do
      expected = {}
      expect(season_stats.worst_ratio).to eq(expected)
    end
  end

  describe '#winningest_coach' do

    it 'returns a string' do
      expect(@season_stats.winningest_coach("20122013")).to be_instance_of(String)
    end

    it 'gives name of Coach with best win percentage of season' do
      expect(@season_stats.winningest_coach("20122013")).to eq("Dave Tippett")
    end
  end

  describe '#worst_coach' do

    it 'returns a string' do
      expect(@season_stats.worst_coach("20122013")).to be_a(String)
    end

    it 'gives name of Coach with the worst win percentage for the season' do
      expect(@season_stats.worst_coach("20122013")).to eq("Todd Richards")
    end
  end

  describe '#most_accurate_team' do
    it 'returns a string' do
      expect(@season_stats.most_accurate_team("20122013")).to be_a(String)
    end

    it 'gives name of team with the best ratio of shots to goals for the season' do
      expect(@season_stats.most_accurate_team("20122013")).to eq("LA Galaxy")
    end
  end

  describe '#least_accurate_team' do
    it 'returns a string' do
      expect(@season_stats.least_accurate_team("20122013")).to be_a(String)
    end

    it 'gives name of team with the worst ratio of shots to goals for the season' do
      expect(@season_stats.least_accurate_team("20122013")).to eq("Minnesota United FC")
    end
  end

  describe '#most_tackles' do
    it 'returns a string' do
      expect(@season_stats.most_tackles("20122013")).to be_a(String)
    end

    it 'gives name of team with the most tackles in the season' do
      expect(@season_stats.most_tackles("20122013")).to eq("FC Cincinnati")
    end
  end

  describe '#fewest_tackles' do
    it 'returns a string' do
      expect(@season_stats.fewest_tackles("20122013")).to be_a(String)
    end

    it 'gives name of team with the fewest tackles in the season' do
      expect(@season_stats.fewest_tackles("20122013")).to eq("Minnesota United FC")
    end
  end
end
end 
