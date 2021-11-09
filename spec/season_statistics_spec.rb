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


  ## Write a method for season_games method?

  describe '#winningest_coach' do

    it 'returns a string' do
      expect(@season_stats.winningest_coach("20122013")).to be_instance_of(String)
    end

    it 'gives name of Coach with best win percentage of season' do
      expect(@season_stats.winningest_coach("20122013")).to eq("Dave Tippett")
    end
  end

end
