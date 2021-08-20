# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan
  before_action :check_user_owns_plan, only: :update

  def show
    @schedules = @plan.schedules
  end

  def update
    target = if params[:add_schedule_id] || params[:remove_schedule_id]
               add_and_remove_plans
             elsif params[:edit_memo_schedule_id]
               edit_memo
             elsif params[:description]
               edit_description
             else
               head :bad_request
             end

    redirect_to redirect_path_with_identifier(target)
  end

  def create
    @plan = @user.plans.create!(title: 'My Plans')
    redirect_to plan_path @plan
  end

  private

  def redirect_path_with_identifier(target)
    identifier = target&.start_at&.strftime('%Y-%m-%d')
    (request.referer || schedules_path) + (identifier ? "##{identifier}" : '')
  end

  def set_plan
    @plan = params[:id] ? Plan.find(params[:id]) : nil
  end

  def add_and_remove_plans
    ret = nil
    ActiveRecord::Base.transaction do
      ret = add_plan if params[:add_schedule_id]
      ret = remove_plan if params[:remove_schedule_id]
    end
    ret
  end

  def add_plan
    ps = @plan.plan_schedules.build(schedule: Schedule.find(params[:add_schedule_id]))
    if @plan.valid?
      ps.save!
    else
      flash[:error] = @plan.errors.messages[:schedules]
    end
    ps.schedule
  end

  def remove_plan
    schedule = Schedule.find(params[:remove_schedule_id])
    @plan.plan_schedules.find_by(schedule: schedule).destroy!
    schedule
  end

  def edit_memo
    schedule = Schedule.find(params[:edit_memo_schedule_id])
    plan_schedule = @plan.plan_schedules.find_by(schedule: schedule)
    plan_schedule.update!(memo: params[:memo])
    schedule
  end

  def edit_description
    @plan.update!(description: params[:description])
    nil
  end

  def check_user_owns_plan
    return render :bad_request if @plan.nil?
    return render :bad_request unless @user.plans.include?(@plan)
  end
end
