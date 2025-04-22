# frozen_string_literal: true

module Admin
  class StatisticsController < AdminController
    CREATE_AT_QUERY = "strftime('%Y-%m-%d', created_at) AS date, COUNT(*) as count"

    def index
      @profiles = profiles_statistics
      @friends = friends_statistics
      @teams = teams_statistics
      @teammates = teammate_statistics
    end

    private

    def profiles_statistics
      Profile.select(CREATE_AT_QUERY).group(:date).order(date: :asc).to_h { [_1.date, _1.count] }
    end

    def friends_statistics
      # friend has 2 records so that count divided by 2
      Friend.select(CREATE_AT_QUERY).group(:date).order(date: :asc).to_h { [_1.date, _1.count / 2] }
    end

    def teams_statistics
      Team.select(CREATE_AT_QUERY).group(:date).order(date: :asc).to_h { [_1.date, _1.count] }
    end

    def teammate_statistics
      TeamProfile.select(CREATE_AT_QUERY).group(:date).order(date: :asc).to_h { [_1.date, _1.count] }
    end
  end
end
