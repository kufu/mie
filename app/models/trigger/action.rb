# frozen_string_literal: true

class Trigger
  class Action
    class ParseError < TriggerError; end

    attr_reader :action

    def initialize(action)
      @action = action
    end

    def perform(target)
      check_target_type(target)
      subject_model.create!(trigger_params(target))
    end

    private

    def target_class
      @target_class ||= action['target'].constantize
    rescue NameError
      raise ParseError, "#{action['model']} is not valid model name"
    end

    def model_class
      @model_class ||= action['model'].constantize
    rescue NameError
      raise ParseError, "#{action['model']} is not valid model name"
    end

    def trigger_params(target)
      action['props'].transform_values do |v|
        v == 'target' ? target.id : v
      end
    end

    def check_target_type(target)
      return if target.instance_of?(target_class)

      raise ParseError, "Target type [#{target.class}] is not instance of #{target_class}"
    end

    def subject_model
      subject = model_class
      return subject if subject.ancestors.include?(ApplicationRecord)

      raise ParseError, "#{subject} is not ActiveRecord models"
    end
  end
end
