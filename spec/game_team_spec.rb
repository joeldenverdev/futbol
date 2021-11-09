require 'csv'
require './lib/game_team'

describe GameTeam do
  let(:game_team_obj) {GameTeam.new({game_id:"2012030221",
                                    team_id:"3",
                                     hoa:"away",
                                    result:"LOSS",
                                    settled_in:"OT",
                                    head_coach:"John Tortorella",
                                    goals:"2",
                                    shots:"8",
                                    tackles:"44",
                                    pim:"8",
                                    powerplayopportunities:"3",
                                    powerplaygoals:"0", faceoffwinpercentage:"44.8",
                                    giveaways:"17",
                                    takeaways:"7"})}

  before(:each) do
    game_teams_path = './data/game_teams_tester.csv'

    locations = {
      game_teams: game_teams_path
    }

    CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol) do |row|
      @game_team = GameTeam.new(row)
    end
  end

  it 'exists' do
    expect(@game_team).to be_instance_of(GameTeam)
  end

  it 'has game_id' do
    expect(@game_team.game_id).to eq "2014020716"
  end

  it 'has team_id' do
    expect(@game_team.team_id).to eq "14"
  end

  it 'has hoa' do
    expect(@game_team.hoa).to eq "home"
  end

  it 'has result' do
    expect(@game_team.result).to eq "WIN"
  end

  it 'has settled_in' do
    expect(@game_team.settled_in).to eq "REG"
  end

  it 'has head_coach' do
    expect(@game_team.head_coach).to eq "Jon Cooper"
  end

  it 'has goals' do
    expect(@game_team.goals).to eq 3
  end

  it 'has shots' do
    expect(@game_team.shots).to eq 8
  end

  it 'has tackles' do
    expect(@game_team.tackles).to eq 13
  end

  it 'has pim' do
    expect(@game_team.pim).to eq "11"
  end

  it 'has power_play_opportunities' do
    expect(@game_team.power_play_opportunities).to eq 2
  end

  it 'has power_play_goals' do
    expect(@game_team.power_play_goals).to eq 1
  end

  it 'has face_off_win_percentage' do
    expect(@game_team.face_off_win_percentage).to eq 54.2
  end

  it 'has giveaways' do
    expect(@game_team.giveaways).to eq 8
  end

  it 'has takeaways' do
    expect(@game_team.takeaways).to eq 11
  end
end
