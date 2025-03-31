# frozen_string_literal: true

class PlansController < ApplicationController
  include EventRouting
  include ProfileScheduleMapping

  before_action :set_plan, except: :create
  before_action :check_user_owns_plan, only: :update

  def show
    @schedules = @plan.schedules
    @plan_table = Schedule::Tables.from_event(@event).expect(@schedules)
    set_friends_and_teammates_schedules_mapping
  end

  def update
    @plan.update!(plan_params)
    redirect_to event_path(event_name: @event.name)
  end

  def editable
    create_and_set_user unless @user
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
    create_and_set_user unless @user
    @plan = @user.plans.where(event: @event).create!(plan_params)
    add_plan(params[:plan][:add_schedule_id]) if params[:plan][:add_schedule_id]
    session[:breakout_turbo] = true
    redirect_to event_path(@plan.event.name)
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :description, :public)
  end

  def set_plan
    @plan = Plan.on_event(@event).find(params[:id])
    raise ActiveRecord::RecordNotFound if @plan.user != @user && !@plan.public?
  end

  def add_plan(id)
    ps = @plan.plan_schedules.build(schedule: Schedule.find(id))
    if @plan.valid?
      ps.save!
    else
      flash[:error] = @plan.errors.messages[:schedules]
      redirect_to event_path(event_name: @plan.event.name) and return
    end
  end

  def check_user_owns_plan
    render status: :bad_request, body: nil if @plan.nil?
    render status: :forbidden, body: nil unless @user.plans.include?(@plan)
  end

  def edit_password_and_visibility
    @plan.password = params[:plan][:password] if params[:plan][:password] != ''
    @plan.public = params[:plan][:public] == 'true'
    @plan.save!
    nil
  end
end
