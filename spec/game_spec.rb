require './lib/game'

RSpec.describe Game do

  let(:game) {Game.new({
    game_id:      "15",
    season:       "25",
    type:         "postseason",
    date_time:    "5/16/13",
    away_team_id: "3",
    home_team_id: "6",
    away_goals:   "2",
    home_goals:   "5",
    venue:        "Toyota Stadium",
    venue_link:   "/api/v1/venues/null"
    })}

    let(:game_1) {Game.new({
      game_id:      "30",
      season:       "70",
      type:         "postseason",
      date_time:    "5/20/13",
      away_team_id: "1",
      home_team_id: "2",
      away_goals:   "4",
      home_goals:   "3",
      venue:        "Toyota Stadium",
      venue_link:   "/api/v1/venues/null"
      })}

      let(:game_2) {Game.new({
        game_id:      "30",
        season:       "70",
        type:         "postseason",
        date_time:    "5/20/13",
        away_team_id: "1",
        home_team_id: "2",
        away_goals:   "7",
        home_goals:   "7",
        venue:        "Toyota Stadium",
        venue_link:   "/api/v1/venues/null"
        })}

  describe '#initialize' do
    it 'exists' do
      expect(game).to be_instance_of Game
    end

    it 'has a game id' do
      expect(game.game_id).to be_instance_of String

      expect(game.game_id).to eq("15")
    end

    it 'has a season id' do
      expect(game.season).to be_instance_of String

      expect(game.season).to eq "25"
    end

    it 'has a type' do
      expect(game.type).to be_instance_of String

      expect(game.type).to eq "postseason"
    end

    it 'a date and time' do
      expect(game.date_time).to be_instance_of String

      expect(game.date_time).to eq "5/16/13"
    end

    it 'has away team id' do
      expect(game.away_team_id).to be_instance_of Integer

      expect(game.away_team_id).to eq 3
    end

    it 'has home team id' do
      expect(game.home_team_id).to be_instance_of Integer

      expect(game.home_team_id).to eq 6
    end

    it 'has away goals' do
      expect(game.away_goals).to be_instance_of Integer

      expect(game.away_goals).to eq 2
    end

    it 'has gome goals' do
      expect(game.home_goals).to be_instance_of Integer

      expect(game.home_goals).to eq 5
    end

    it 'has a venue' do
      expect(game.venue).to be_instance_of String

      expect(game.venue).to eq "Toyota Stadium"
    end

    it 'has a venue link' do
      expect(game.venue_link).to be_instance_of String

      expect(game.venue_link).to eq "/api/v1/venues/null"
    end
  end

  describe '#home_win?' do
    it 'returns true if home win' do
      expect(game.home_win?).to be true

      expect(game_1.home_win?).to be false

      expect(game_2.home_win?).to be false
    end
  end

  describe '#visitor_win?' do
    it 'returns true if visitor win' do
      expect(game.visitor_win?).to be false

      expect(game_1.visitor_win?).to be true

      expect(game_2.visitor_win?).to be false
    end
  end

  describe '#tie_game' do
    it 'returns true if home and away goals are same' do
      expect(game.tie_game?).to be false

      expect(game_1.tie_game?).to be false

      expect(game_2.tie_game?).to be true
    end
  end

  describe '#total_goals' do
    it 'returns combined home and away goals' do
      expect(game.total_goals).to eq 7

      expect(game_1.total_goals).to eq 7

      expect(game_2.total_goals).to eq 14
    end
  end
end
