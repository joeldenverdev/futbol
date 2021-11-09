require 'csv'
require './lib/team'

describe Team do

  let(:team) {Team.new({
    team_id: "1",
    franchise_id: "23",
    team_name: "Atlanta United",
    abbreviation: "ATL",
    stadium: "Mercedes-Benz",
    link: "/api/v1/teams/1"
    })}

  before(:each) do
    team_path = './data/teams_tester.csv'

    locations = {
      teams: team_path
    }

    CSV.foreach(locations[:teams], headers: true, header_converters: :symbol) do |row|
      team = Team.new(row)
    end
  end

  it 'exists' do
    expect(@team).to be_instance_of(Team)
  end

end
