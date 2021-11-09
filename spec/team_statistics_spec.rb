require './lib/team_statistics'
require './lib/stat_tracker'

RSpec.describe TeamStatistics do
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
    @team_stats = @stat_tracker.team_stats
  end

  describe '#initialize' do
    it 'exists' do
      expect(@team_stats).to be_an_instance_of TeamStatistics
    end

    it 'is instantiated with StatTracker' do
      expect(@stat_tracker.team_stats).to be_an_instance_of TeamStatistics
    end
  end

  describe '#team_info' do
    it 'returns team_id, franchise_id, team_name, abbr., and link' do
      expected = {
        "team_id" => "27",
        "franchise_id" => "28",
        "team_name" => "San Jose Earthquakes",
        "abbreviation" => "SJ",
        "link" => "/api/v1/teams/27"
      }
      expect(@team_stats.team_info("27")).to eq(expected)
    end
  end

  # Total by season

  # Wins by season

  # Games by team

  # Wins by team

  # Team game IDs

  # Won game ids

  describe '#best_season' do
    it 'returns the season with the highest win percentage for a team' do
      expect(@team_stats.best_season("3")).to eq("20142015")
    end
  end

  describe '#worst_season' do
    it 'returns the season with the lowest win percentage for a team' do
      expect(@team_stats.worst_season("3")).to eq("20152016")
    end
  end

  describe '#average_win_percentage' do
    it 'returns the average win percentage of all games for a team' do
      expect(@team_stats.average_win_percentage("3")).to eq(0.36)
    end
  end

  describe '#most_goals_scored' do
    it 'returns the highest nuber of goals a particular team has scored in a single game' do
      expect(@team_stats.most_goals_scored("3")).to eq(5)
    end
  end

  describe '#fewest_goals_scored' do
    it 'returns the lowest numer of goals a particular team has scored in a single game' do
      expect(@team_stats.fewest_goals_scored("3")).to eq(0)
    end
  end

  describe '#favorite_opponent' do
    it 'returns the name of the opponent that has the lowest win percentage against the given team' do
      expect(@team_stats.favorite_opponent("3")).to eq("Atlanta United")
    end
  end

  describe '#rival' do
    it 'returns the name of the opponent that has the highest win percentage against the given team' do
      expect(@team_stats.rival("3")).to eq("FC Dallas")
    end
  end

end
