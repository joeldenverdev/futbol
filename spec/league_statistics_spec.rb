require './lib/league_statistics'
require './lib/stat_tracker'

RSpec.describe LeagueStatistics do
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
    @league_stats = @stat_tracker.league_stats
  end

  describe '#count of teams' do
    it 'returns total number of teams' do
      expect(@league_stats.count_of_teams).to eq(32)
    end

    it 'returns an integer' do
      expect(@league_stats.count_of_teams).to be_instance_of(Integer)
    end
  end

  describe '#best_offense' do
    it 'returns team with most avg goals per game for all seasons' do
      expect(@league_stats.best_offense).to eq("FC Dallas")
    end

    it 'returns a string' do
      expect(@league_stats.best_offense).to be_instance_of(String)
    end
  end

  describe '#games_by_team' do
    it 'returns number of games per team by team_id' do
      expect(@league_stats.games_by_team(3).length).to eq(42)
    end
  end

  describe '#total_goals_by_team' do
    it 'returns number of total goals by team_id' do
      expect(@league_stats.total_goals_by_team(3)).to eq(73)
    end
  end

  describe '#average_goals_per_game_by_team' do
    it 'returns number of average goals per game by team_id' do
      expect(@league_stats.average_goals_per_game_by_team(3)).to eq(1.74)
    end
  end

end
