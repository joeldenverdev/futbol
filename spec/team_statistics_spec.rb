require './lib/team_statistics'
require './lib/stat_tracker'
require './lib/game'

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
    @game_ids = [
      "2012030221away", "2012030222away", "2012030223home", "2012030224home",
      "2012030225away", "2012030131away", "2012030132away", "2012030133home",
      "2012030134home", "2012030135away", "2012030136home", "2012030137away",
      "2015030141away", "2015030142away", "2015030143home", "2015030144home",
      "2015030145away", "2014030131home", "2014030132home", "2014030133away",
      "2014030134away", "2014030135home", "2014030311home", "2014030312home",
      "2014030313away", "2014030314away", "2014030315home", "2014030316away",
      "2014030317home", "2014030221home", "2014030222home", "2014030223away",
      "2014030224away", "2014030225home", "2014030226away", "2014030227home",
      "2013020444home", "2013020723away", "2013020760home", "2012020396away",
      "2013020868away","2012020495away"
      ]

      @won_game_ids = [
        "2012030136", "2012030137", "2014030131", "2014030132",
        "2014030133", "2014030134", "2014030135", "2014030311", "2014030314",
        "2014030316", "2014030222", "2014030225", "2014030227", "2013020444",
        "2013020723"
        ]

        @won_game_team_ids = [
        "2012030221away", "2012030222away", "2012030223home",
        "2012030224home", "2012030225away", "2012030131away", "2012030132away",
        "2012030133home", "2012030134home", "2012030135away", "2012030136home",
        "2012030137away", "2015030141away", "2015030142away", "2015030143home",
        "2015030144home", "2015030145away", "2014030131home", "2014030132home",
        "2014030133away", "2014030134away", "2014030135home", "2014030311home",
        "2014030312home", "2014030313away", "2014030314away", "2014030315home",
        "2014030316away", "2014030317home", "2014030221home", "2014030222home",
        "2014030223away", "2014030224away", "2014030225home", "2014030226away",
        "2014030227home", "2013020444home", "2013020723away", "2013020760home",
        "2012020396away", "2013020868away","2012020495away"
        ]
  end

  describe '#initialize' do
    it 'exists' do
      expect(@team_stats).to be_an_instance_of TeamStatistics
    end

    it 'is instantiated with StatTracker' do
      expect(@stat_tracker.team_stats).to be_an_instance_of TeamStatistics
    end

    it 'can access Game objects' do
      expect(@team_stats.games[0]).to be_an_instance_of Game
    end

    it 'can access Team objects' do
      expect(@team_stats.teams[0]).to be_an_instance_of Team
    end

    it 'can access GameTeam objects' do
      expect(@team_stats.game_teams[0]).to be_an_instance_of GameTeam
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

  describe '#total_by_season' do
    it 'returns a hash of season_id keys and game count values' do
      expected = {
        "20122013"=>14,
        "20152016"=>5,
        "20142015"=>19,
        "20132014"=>4
      }
      expect(@team_stats.total_by_season(@game_ids)).to eq(expected)
    end

    it 'returns a hash' do
      expect(@team_stats.total_by_season(@game_ids)).to be_a Hash
    end
  end

  describe '#wins_by_season' do
    it 'returns a hash of season_id keys and win count values' do
      expected = {
        "20122013"=>2,
        "20142015"=>11,
        "20132014"=>2
      }
      expect(@team_stats.wins_by_season(@won_game_ids)).to eq(expected)
    end

    it 'returns a hash' do
      expect(@team_stats.wins_by_season(@won_game_ids)).to be_a Hash
    end
  end

  describe '#games_by_team' do
    it 'returns a hash of game_team keys and game count values' do
      expected = {
        "6"=>5,
        "15"=>14,
        "5"=>11,
        "14"=>7,
        "1"=>1,
        "9"=>2,
        "19"=>1,
        "52"=>1
      }
      expect(@team_stats.games_by_team(@game_ids, "3")).to eq(expected)
    end
    it 'returns a hash' do
      expect(@team_stats.games_by_team(@game_ids, "3")).to be_a Hash
    end
  end

  describe '#wins_by_team' do
    it 'returns a hash of team_id keys and win count values' do
      expected = {"6"=>5, "15"=>9, "5"=>4, "14"=>4, "19"=>1, "52"=>1, "9"=>1}
      expect(@team_stats.wins_by_team(@game_ids, "3")).to eq(expected)
    end
  end

  describe '#team_game_ids' do
    it 'returns an array of all game ids for a team' do
      expect(@team_stats.team_game_ids("3")).to eq(@game_ids)
    end
  end

  describe '#won_game_ids' do
    it 'returns an array of all winning game ids for a team' do
      expect(@team_stats.team_game_ids("3")).to eq(@won_game_team_ids)
    end
  end

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
