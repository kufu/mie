# frozen_string_literal: true

class PlansController < ApplicationController
  include EventRouting

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
             elsif params[:visibility]
               edit_password_and_visibility
             elsif params[:title]
               edit_title
             else
               head :bad_request
             end

    redirect_to redirect_path_with_identifier(target)
  end

  def editable
    if @plan.password == params[:password]
      @plan.update!(user: @user)
      redirect_to event_plan_path(@plan, event_name: @plan.event.name)
    else
      flash[:error] = I18n.t('errors.password_incorrect')
      head :unauthorized
    end
  rescue StandardError
    flash[:error] = I18n.t('errors.password_incorrect')
    head :unauthorized
  end

  def create
    @plan = @user.plans.create!(title: 'My Plans')
    redirect_to event_plan_path(@plan, event_name: @plan.event.name)
  end

  private

  def redirect_path_with_identifier(target)
    identifier = target&.start_at&.strftime('%Y-%m-%d')
    (request.referer || schedules_path) + (identifier ? "##{identifier}" : '')
  end

  def set_plan
    @plan = Plan.find(params[:id] || params[:plan_id])
    raise ActiveRecord::RecordNotFound if @plan.user != @user && !@plan.public?
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
      redirect_to event_schedules_path(event_name: @plan.event.name) && return
    end
    @plan.update!(initial: false)
    ps.schedule
  end

  def remove_plan
    schedule = Schedule.find(params[:remove_schedule_id])
    @plan.plan_schedules.find_by(schedule:).destroy!
    @plan.update!(initial: false)
    schedule
  end

  def edit_memo
    schedule = Schedule.find(params[:edit_memo_schedule_id])
    plan_schedule = @plan.plan_schedules.find_by(schedule:)
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

  def edit_password_and_visibility
    @plan.password = params[:password] if params[:password] != ''
    @plan.public = params[:visibility] == 'true'
    @plan.save!
    nil
  end

  def edit_title
    @plan.update(title: params[:title])
    nil
  end
end
