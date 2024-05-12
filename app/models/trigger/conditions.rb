# frozen_string_literal: true

class Trigger
  class Conditions
    attr_reader :conditions, :target

    def initialize(conditions, target)
      @conditions = conditions
      @target = target
    end

    def satisfy?
      return true if conditions.empty?

      conditions.each do |condition|
        return false unless Condition.new(condition.deep_symbolize_keys, target).satisfy?
      end
    end
  end
end
