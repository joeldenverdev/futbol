require 'csv'
require './lib/stat_tracker'

RSpec.describe StatTracker do
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
  end

  describe '#initialize' do

    it 'exists' do
      expect(@stat_tracker).to be_instance_of(StatTracker)
    end
  end

  # Game Statistics Tests

  xdescribe '#highest_total_score' do
    it 'returns an integer' do
      expect(@stat_tracker.highest_total_score).to be_an_instance_of Integer
    end

    it 'returns highest total of winning and losing team score by game' do
      expect(@stat_tracker.highest_total_score).to eq 9
    end
  end

  xdescribe '#lowest_total_score' do
    it 'returns an integer' do
      expect(@stat_tracker.lowest_total_score).to be_an_instance_of Integer
    end

    it 'returns lowest total of winning and losing team score by game' do
      expect(@stat_tracker.lowest_total_score).to eq 1
    end
  end

  xdescribe '#percentage_home_wins' do
    it 'returns a float' do
      expect(@stat_tracker.percentage_home_wins).to be_an_instance_of Float
    end

    it 'percentage of games won by the home team' do
      expected = @stat_tracker.percentage_home_wins

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  xdescribe '#percentage_visitor_wins' do
    it 'returns a float' do
      expect(@stat_tracker.percentage_visitor_wins).to be_an_instance_of Float

      expected = @stat_tracker.percentage_visitor_wins

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  xdescribe '#percentage_ties' do
    it 'returns the percentage of game where the scores were equal' do
      expect(@stat_tracker.percentage_ties).to be_an_instance_of Float

      expected = @stat_tracker.percentage_ties

      expect(expected).to be < 1

      expect(expected).to eq(expected.round(2))
    end
  end

  xdescribe '#percentage calculator methods' do
    it 'equals 1' do
      wins = @stat_tracker.percentage_visitor_wins

      losses = @stat_tracker.percentage_visitor_wins

      ties = @stat_tracker.percentage_ties

      total = wins + losses + ties

      expect(total.round).to eq 1
      expect(total).to be > 0.9
    end
  end

  xdescribe '#count_of_games_by_season' do
    it 'returns array with season id as key and count as value' do
      @stat_tracker.count_of_games_by_season
      expect(@stat_tracker.count_of_games_by_season).to be_an_instance_of Hash
    end
  end

  xdescribe '#average_goals_per_game' do
    it 'divides the total number of goals by the total number of games' do
      expect(@stat_tracker.average_goals_per_game).to be_an_instance_of Float

      expect(@stat_tracker.average_goals_per_game).to eq 4.18
    end
  end

  xdescribe '#average_goals_by_season' do
    it 'returns hash with season id as key and float of average number of goals per game as value' do
      expect(@stat_tracker.average_goals_by_season).to be_an_instance_of Hash
    end

    it 'has season numbers as keys' do
      expect(@stat_tracker.average_goals_by_season.keys.include?("20122013")).to be_truthy

      expect(@stat_tracker.average_goals_by_season.keys.include?("20162017")).to be_truthy

      expect(@stat_tracker.average_goals_by_season.keys.include?("20172018")).to be_truthy

      first_season_goals = @stat_tracker.average_goals_by_season.values[0]

      expect(first_season_goals).to eq(first_season_goals.round(2))
    end
  end

  # Season Statistics Tests

  xdescribe '#winningest_coach' do

    it 'returns a string' do
      expect(@stat_tracker.winningest_coach("20122013")).to be_instance_of(String)
    end

    it 'gives name of Coach with best win percentage of season' do
      expect(@stat_tracker.winningest_coach("20122013")).to eq("Dave Tippett")
    end
  end

  xdescribe '#worst_coach' do

    it 'returns a string' do
      expect(@stat_tracker.worst_coach("20122013")).to be_a(String)
    end

    it 'gives name of Coach with the worst win percentage for the season' do
      expect(@stat_tracker.worst_coach("20122013")).to eq("Todd Richards")
    end
  end

  xdescribe '#most_accurate_team' do
    it 'returns a string' do
      expect(@stat_tracker.most_accurate_team("20122013")).to be_a(String)
    end

    it 'gives name of team with the best ratio of shots to goals for the season' do
      expect(@stat_tracker.most_accurate_team("20122013")).to eq("LA Galaxy")
    end
  end

  xdescribe '#least_accurate_team' do
    it 'returns a string' do
      expect(@stat_tracker.least_accurate_team("20122013")).to be_a(String)
    end

    it 'gives name of team with the worst ratio of shots to goals for the season' do
      expect(@stat_tracker.least_accurate_team("20122013")).to eq("Minnesota United FC")
    end
  end

  xdescribe '#most_tackles' do
    it 'returns a string' do
      expect(@stat_tracker.most_tackles("20122013")).to be_a(String)
    end

    it 'gives name of team with the most tackles in the season' do
      expect(@stat_tracker.most_tackles("20122013")).to eq("FC Cincinnati")
    end
  end

  xdescribe '#fewest_tackles' do
    it 'returns a string' do
      expect(@stat_tracker.fewest_tackles("20122013")).to be_a(String)
    end

    it 'gives name of team with the fewest tackles in the season' do
      expect(@stat_tracker.fewest_tackles("20122013")).to eq("Minnesota United FC")
    end
  end

  # League Statistics Tests

  xdescribe '#count of teams' do
    it 'returns total number of teams' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end

    it 'returns an integer' do
      expect(@stat_tracker.count_of_teams).to be_instance_of(Integer)
    end
  end

  xdescribe '#best_offense' do
    it 'returns team with most avg goals per game for all seasons' do
      expect(@stat_tracker.best_offense).to eq("FC Dallas")
    end

    it 'returns a string' do
      expect(@stat_tracker.best_offense).to be_instance_of(String)
    end
  end

  # describe '#games_by_team' do
  #   it 'returns number of games per team by team_id' do
  #     expect(@stat_tracker.games_by_team(3).length).to eq(42)
  #   end
  # end

  # describe '#total_goals_by_team' do
  #   it 'returns number of total goals by team_id' do
  #     expect(@stat_tracker.total_goals_by_team(3)).to eq(73)
  #   end
  # end
  #
  # describe '#average_goals_per_game_by_team' do
  #   it 'returns number of average goals per game by team_id' do
  #     expect(@stat_tracker.average_goals_per_game_by_team(3)).to eq(1.74)
  #   end
  # end

  xdescribe '#worst_offense' do
    it 'returns team with least avg goals per game for all seasons' do
      expect(@stat_tracker.worst_offense).to eq("Sky Blue FC")
    end

    it 'returns a string' do
      expect(@stat_tracker.worst_offense).to be_instance_of(String)
    end
  end

  xdescribe '#games_away' do
    it 'returns all away games by team_id' do
      expect(@stat_tracker.games_away(3).length).to eq(22)
    end
  end

  xdescribe '#average_away_score' do
    it 'returns average score per away game by team_id' do
      expect(@stat_tracker.average_away_score(3)).to eq(1.9)
    end
  end

  xdescribe '#highest_scoring_visitor' do
    it 'returns team with highest avg score for away games' do
      expect(@stat_tracker.highest_scoring_visitor).to eq("Columbus Crew SC")
    end

    it 'returns a string' do
      expect(@stat_tracker.highest_scoring_visitor).to be_instance_of(String)
    end
  end

  xdescribe '#highest_scoring_home_team' do
    it 'returns team with highest avg score for home games' do
      expect(@stat_tracker.highest_scoring_home_team).to eq("San Jose Earthquakes")
    end

    it 'returns a string' do
      expect(@stat_tracker.highest_scoring_home_team).to be_instance_of(String)
    end
  end

  xdescribe '#games_home' do
    it 'returns all home games by team_id' do
      expect(@stat_tracker.games_home(3).length).to eq(20)
    end
  end

  xdescribe '#average_home_score' do
    it 'returns average score per home game by team_id' do
      expect(@stat_tracker.average_home_score(3)).to eq(1.6)
    end
  end

  xdescribe '#lowest_scoring_visitor' do
    it 'returns team with lowest avg score for away games' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq("Chicago Fire")
    end

    it 'returns a string' do
      expect(@stat_tracker.lowest_scoring_visitor).to be_instance_of(String)
    end
  end

  xdescribe '#lowest_scoring_home_team' do
    it 'returns team with lowest avg score for home games' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Sky Blue FC")
    end

    it 'returns a string' do
      expect(@stat_tracker.lowest_scoring_home_team).to be_instance_of(String)
    end
  end

  #Team Statistics Tests

  describe '#team_info' do
    it 'returns team_id, franchise_id, team_name, abbr., and link' do
      expected = {
        "team_id" => "27",
        "franchise_id" => "28",
        "team_name" => "San Jose Earthquakes",
        "abbreviation" => "SJ",
        "link" => "/api/v1/teams/27"
      }
      expect(@stat_tracker.team_info("27")).to eq(expected)
    end
  end

  describe '#best_season' do
    it 'returns the season with the highest win percentage for a team' do
      expect(@stat_tracker.best_season("3")).to eq("20142015")
    end
  end

  xdescribe '#worst_season' do
    it 'returns the season with the lowest win percentage for a team' do
      expect(@stat_tracker.worst_season("3")).to eq("20152016")
    end
  end

  xdescribe '#average_win_percentage' do
    it 'returns the average win percentage of all games for a team' do
      expect(@stat_tracker.average_win_percentage("3")).to eq(0.36)
    end
  end

  xdescribe '#most_goals_scored' do
    it 'returns the highest nuber of goals a particular team has scored in a single game' do
      expect(@stat_tracker.most_goals_scored("3")).to eq(5)
    end
  end

  xdescribe '#fewest_goals_scored' do
    it 'returns the lowest numer of goals a particular team has scored in a single game' do
      expect(@stat_tracker.fewest_goals_scored("3")).to eq(0)
    end
  end

  xdescribe '#favorite_opponent' do
    it 'returns the name of the opponent that has the lowest win percentage against the given team' do
      expect(@stat_tracker.favorite_opponent("3")).to eq("Atlanta United")
    end
  end

  xdescribe '#rival' do
    it 'returns the name of the opponent that has the highest win percentage against the given team' do
      expect(@stat_tracker.rival("3")).to eq("FC Dallas")
    end
  end
end
