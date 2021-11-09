require 'csv'
require './lib/team'

describe Team do

  let(:team_obj) {Team.new({
    team_id: "1",
    franchiseid: "23",
    teamname: "Atlanta United",
    abbreviation: "ATL",
    stadium: "Mercedes-Benz",
    link: "/api/v1/teams/1"
    })}

  before(:each) do
    team_path = './data/teams.csv'

    locations = {
      teams: team_path
    }

    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      @team = Team.new(row)
    end
  end

  it 'exists' do
    expect(@team).to be_instance_of(Team)
  end

  it 'has team_id' do
    expect(team_obj.team_id).to eq "1"
  end

  it 'has franchise_id' do
    expect(team_obj.franchise_id).to eq "23"
  end

  it 'has team_name' do
    expect(team_obj.team_name).to eq "Atlanta United"
  end

  it 'has abbreviation' do
    expect(team_obj.abbreviation).to eq "ATL"
  end

  it 'has stadium' do
    expect(team_obj.stadium).to eq "Mercedes-Benz"
  end

  it 'has link' do
    expect(team_obj.link).to eq "/api/v1/teams/1"
  end

end
