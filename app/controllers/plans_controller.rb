# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan
  before_action :check_user_owns_plan, only: :update

  def show
    @schedules = @plan.schedules
  end

  def update
    if params[:add_schedule_id] || params[:remove_schedule_id]
      add_and_remove_plans
    elsif params[:edit_memo_schedule_id]
      edit_memo
    else
      head :bad_request
    end

    redirect_to request.referer || schedules_path
  end

  def create
    @plan = @user.plans.create!(title: 'My Plans')
    redirect_to plan_path @plan
  end

  private

  def set_plan
    @plan = params[:id] ? Plan.find(params[:id]) : nil
  end

  def add_and_remove_plans
    ActiveRecord::Base.transaction do
      add_plan if params[:add_schedule_id]
      remove_plan if params[:remove_schedule_id]
    end
  end

  def add_plan
    ps = @plan.plan_schedules.build(schedule: Schedule.find(params[:add_schedule_id]))
    if @plan.valid?
      ps.save!
    else
      flash[:error] = @plan.errors.messages[:schedules]
    end
  end

  def remove_plan
    @plan.plan_schedules.find_by(schedule: Schedule.find(params[:remove_schedule_id])).destroy!
  end

  def edit_memo
    plan_schedule = @plan.plan_schedules.find_by(schedule_id: params[:edit_memo_schedule_id])
    plan_schedule.update!(memo: params[:memo])
  end

  def check_user_owns_plan
    return render :bad_request if @plan.nil?
    return render :bad_request unless @user.plans.include?(@plan)
  end
end
