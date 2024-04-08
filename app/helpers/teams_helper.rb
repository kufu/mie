# frozen_string_literal: true

module TeamsHelper
  def team_name_max_length
    Team.validators_on(:name).detect do |v|
      v.is_a?(ActiveModel::Validations::LengthValidator)
    end.options[:maximum]
  end
end
