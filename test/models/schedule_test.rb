# frozen_string_literal: true

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'title length must greater than 0, less than 100' do
    s = schedules(:one)

    s.title = ''
    assert_not s.valid?

    s.title = 'Something new'
    assert s.valid?

    s.title = 'あ' * 100
    assert s.valid?

    s.title = 'い' * 101
    assert_not s.valid?
  end

  test 'description length must greater equal than 0, less than 1024' do
    s = schedules(:one)

    s.description = nil
    assert_not s.valid?

    s.description = ''
    assert s.valid?

    s.description = 'Yeah'
    assert s.valid?

    s.description = 'あ' * 1024
    assert s.valid?

    s.description = 'い' * 1025
    assert_not s.valid?
  end

  test 'track name must greater than 0, less than 32' do
    s = schedules(:one)

    s.track_name = ''
    assert_not s.valid?

    s.track_name = 'TrackA'
    assert s.valid?

    s.track_name = 'あ' * 32
    assert s.valid?

    s.track_name = 'い' * 33
    assert_not s.valid?
  end

  test 'language must be presented' do
    s = schedules(:one)

    s.language = :en
    assert s.valid?

    s.language = :ja
    assert s.valid?

    s.language = nil
    assert_not s.valid?
  end
end
