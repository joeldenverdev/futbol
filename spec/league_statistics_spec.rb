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

  describe '#initialize' do
    it 'exists' do
      expect(@league_stats).to be_an_instance_of LeagueStatistics
    end

    it 'has access to CSVs in array format' do
      expect(@league_stats.games).to be_instance_of Array
      expect(@league_stats.teams).to be_instance_of Array
      expect(@league_stats.game_teams).to be_instance_of Array
    end

    it 'is intialized as StatTracker class variable' do
      expect(@stat_tracker.league_stats).to be_an_instance_of LeagueStatistics
    end
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

  describe '#team_name_by_id' do
    it 'returns team name after being given team id' do
      expect(@league_stats.team_name_by_id('3')).to eq("Houston Dynamo")
    end
  end

  describe '#average_goals_per_game_by_team' do
    it 'returns number of average goals per game by team_id' do
      expect(@league_stats.average_goals_per_game_by_team('3')).to eq(1.74)
    end
  end

  describe '#total_goals_by_team' do
    it 'returns number of total goals by team_id' do
      expect(@league_stats.total_goals_by_team('3')).to eq(73)
    end
  end

  describe '#games_by_team' do
    it 'returns number of games per team by team_id' do
      expect(@league_stats.games_by_team('3').length).to eq(42)
    end
  end

  describe '#worst_offense' do
    it 'returns team with least avg goals per game for all seasons' do
      expect(@league_stats.worst_offense).to eq("Sky Blue FC")
    end

    it 'returns a string' do
      expect(@league_stats.worst_offense).to be_instance_of(String)
    end
  end

  describe '#games_away' do
    it 'returns all away games by team_id' do
      expect(@league_stats.games_away('3').length).to eq(22)
    end
  end

  describe '#average_away_score' do
    it 'returns average score per away game by team_id' do
      expect(@league_stats.average_away_score('3')).to eq(1.9)
    end
  end

  describe '#highest_scoring_visitor' do
    it 'returns team with highest avg score for away games' do
      expect(@league_stats.highest_scoring_visitor).to eq("Columbus Crew SC")
    end

    it 'returns a string' do
      expect(@league_stats.highest_scoring_visitor).to be_instance_of(String)
    end
  end

  describe '#games_home' do
    it 'returns all home games by team_id' do
      expect(@league_stats.games_home('3').length).to eq(20)
    end
  end

  describe '#average_home_score' do
    it 'returns average score per home game by team_id' do
      expect(@league_stats.average_home_score('3')).to eq(1.6)
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns team with highest avg score for home games' do
      expect(@league_stats.highest_scoring_home_team).to eq("San Jose Earthquakes")
    end

    it 'returns a string' do
      expect(@league_stats.highest_scoring_home_team).to be_instance_of(String)
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'returns team with lowest avg score for away games' do
      expect(@league_stats.lowest_scoring_visitor).to eq("Chicago Fire")
    end

    it 'returns a string' do
      expect(@league_stats.lowest_scoring_visitor).to be_instance_of(String)
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns team with lowest avg score for home games' do
      expect(@league_stats.lowest_scoring_home_team).to eq("Sky Blue FC")
    end

    it 'returns a string' do
      expect(@league_stats.lowest_scoring_home_team).to be_instance_of(String)
    end
  end

end
