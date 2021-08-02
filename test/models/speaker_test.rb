# frozen_string_literal: true

require 'test_helper'

class SpeakerTest < ActiveSupport::TestCase
  test 'name length must greater than 0, less than 100' do
    s = speakers(:johnny)

    s.name = ''
    assert_not s.valid?

    s.name = 'Johnny Silverhand'
    assert s.valid?

    s.name = 'J' * 100
    assert s.valid?

    s.name = 'あ' * 101
    assert_not s.valid?
  end

  test 'handle length must greater equal than 0, less than 100' do
    s = speakers(:johnny)

    s.handle = nil
    assert_not s.valid?

    s.handle = ''
    assert s.valid?

    s.handle = 'Johnny Silverhand'
    assert s.valid?

    s.handle = 'J' * 100
    assert s.valid?

    s.handle = 'あ' * 101
    assert_not s.valid?
  end

  test 'profile length must greater equal than 0, less than 1024' do
    s = speakers(:johnny)

    s.profile = ''
    assert_not s.valid?

    s.profile = 'Rocker boy'
    assert s.valid?

    s.profile = 'J' * 1024
    assert s.valid?

    s.profile = 'あ' * 1025
    assert_not s.valid?
  end

  test 'thumbnail length must greater equal than 0, less than 1024' do
    s = speakers(:johnny)

    s.thumbnail = ''
    assert_not s.valid?

    s.thumbnail = 'https://example.com/assets/image/hoge.jpg'
    assert s.valid?

    s.thumbnail = 'J' * 1024
    assert s.valid?

    s.thumbnail = 'K' * 1025
    assert_not s.valid?
  end
end
