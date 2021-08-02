# frozen_string_literal: true

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  test 'title length must greater than 0, less than 100' do
    p = plans(:one)

    p.title = ''
    assert_not p.valid?

    p.title = 'Something new'
    assert p.valid?

    p.title = 'あ' * 100
    assert p.valid?

    p.title = 'い' * 101
    assert_not p.valid?
  end

  test 'description length must greater equal than 0, less than 1024' do
    p = plans(:one)

    p.description = nil
    assert_not p.valid?

    p.description = ''
    assert p.valid?

    p.description = 'Yeah'
    assert p.valid?

    p.description = 'あ' * 1024
    assert p.valid?

    p.description = 'い' * 1025
    assert_not p.valid?
  end

  test 'public status must be present' do
    p = plans(:one)

    p.public = nil
    assert_not p.valid?
  end
end
