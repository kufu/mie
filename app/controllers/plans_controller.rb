# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan
  before_action :set_plan_for_user

  def index
    @schedules = @user_plan.schedules
  end

  def show
    @schedules = @plan.schedules
  end

  private

  def set_plan
    @plan = params[:id] ? Plan.find(params[:id]) : nil
  end

  def set_plan_for_user
    @user_plan = if @user.plans.present?
                   @user.plans.first
                 else
                   @user.plans.create!(title: 'Plans for RubyKaigi Takeout 2021')
                 end
  end
end
