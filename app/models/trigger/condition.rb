# frozen_string_literal: true

class Trigger
  class Condition
    UndefinedActionError = Class.new(TriggerError)
    UndefinedOperatorError = Class.new(TriggerError)
    InvalidModelError = Class.new(TriggerError)

    attr_reader :condition, :target, :props, :attribute

    def initialize(condition, target)
      @condition = condition
      @target = target
    end

    def satisfy?
      @props = condition[:props].transform_values { transform_target(_1) }
      check
    end

    private

    def transform_target(value)
      case Array(value).map(&:to_sym)
      in [:target]
        target_model
      in [:target, *attrs]
        attrs.inject(target_model) { |acc, attr| acc&.public_send(attr) }
      else
        value
      end
    end

    def check
      cond = condition[:action].is_a?(Hash) ? condition[:action].deep_symbolize_keys : condition[:action].to_sym
      @attribute = cond.delete(:attribute) if cond.is_a?(Hash)

      case cond
      in :exists
        count_check(0, 'gt')
      in :not_exists
        count_check(0, 'eq')
      in { compare: op, value: value}
        compare_check(op, value)
      in { count: num, operator: op }
        count_check(num, op)
      in { includes: includes }
        includes_check(includes)
      else
        raise UndefinedActionError, "Action '#{condition[:action]}' is not defined.'"
      end
    end

    def subject_model
      @subject_model ||= if condition[:eager_load]
                           inflate_model(condition[:model]).eager_load(condition[:eager_load])
                         else
                           inflate_model(condition[:model])
                         end
    end

    def inflate_model(model_name)
      model = model_name.constantize
      return model if model.ancestors.include?(ApplicationRecord)

      raise InvalidModelError, "#{model} is not subclass of ApplicationRecord."
    end

    def target_model
      @target_model ||= if @target.instance_of?(inflate_model(condition[:target]))
                          @target
                        else
                          raise(InvalidModelError, "#{@target.class} is not match target #{condition[:target]}")
                        end
    end

    def resolve_model_attribute
      objects = subject_model.where(props)
      Array(@attribute).inject(objects) { |acc, attr| acc.map { _1&.public_send(attr) } }
    end

    def compare_check(operator, value)
      subject = resolve_model_attribute.first
      case operator
      when 'eq'
        subject == value
      when 'not_eq'
        subject != value
      end
    end

    def count_check(num, operator)
      count = resolve_model_attribute.count
      case operator
      when 'eq'
        count == num
      when 'gt'
        count > num
      when 'gteq'
        count >= num
      when 'lt'
        count < num
      when 'lteq'
        count <= num
      else
        raise UndefinedOperatorError, "Operator '#{operator}' is not defined."
      end
    end

    def includes_check(includes)
      resolve_model_attribute.any? { |obj| includes.include?(obj) }
    end
  end
end
