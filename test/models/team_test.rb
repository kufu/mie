# frozen_string_literal: true

require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test 'name length must larger than 0' do
    team = Team.new(name: '')
    assert_not team.valid?
  end

  test 'name length must less than 65' do
    team = Team.new(name: 'a' * 65)
    assert_not team.valid?
  end

  test 'name length must be larger than 0 and less than 65' do
    team = Team.new(name: 'a')
    assert team.valid?

    team = Team.new(name: 'a' * 10)
    assert team.valid?

    team = Team.new(name: 'a' * 32)
    assert team.valid?

    team = Team.new(name: 'a' * 64)
    assert team.valid?
  end

  test 'team name must uniq' do
    Team.create!(name: 'test team')
    team = Team.new(name: 'test team')
    assert_not team.valid?
  end
end
