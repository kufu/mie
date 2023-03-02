# frozen_string_literal: true

require 'test_helper'

class ScheduleSpeakerTest < ActiveSupport::TestCase
  test 'assign speaker to schedule on same event' do
    target = ScheduleSpeaker.create(schedule: schedules(:dojo_one), speaker: speakers(:cat))
    assert target.valid?
  end

  test "Can't assign speaker to schedule managed by other event" do
    target = ScheduleSpeaker.create(schedule: schedules(:dojo_one), speaker: speakers(:johnny))
    assert target.invalid?
  end
end
