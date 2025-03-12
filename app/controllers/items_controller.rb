# frozen_string_literal: true

class ItemsController < ApplicationController
  include EventRouting
  include ScheduleTable

  before_action :set_event
  before_action :set_item, only: %i[update destroy]
  before_action :set_plan
  before_action :build_item, only: %i[create]
  before_action :check_user_owns_plan
  before_action :check_item_belongs_to_event

  def create
    if @plan.valid?
      @item.save!
    else
      flash[:error] = @plan.errors.messages[:schedules]
      redirect_to event_plan_path(@plan, event_name: @event.name) and return
    end
    @plan.update!(initial: false) if @plan.initial

    redirect_to event_schedules_path(@event.name)
  end

  def update
    @item.update!(item_params)
    render 'schedules/_card', locals: { schedule: @item.schedule, mode: :plan, inactive: false }
  end

  def destroy
    @item.destroy!
    @plan.update!(initial: false)

    redirect_to event_schedules_path(@event.name)
  end

  private

  def item_params
    params.require(:plan_schedule).permit(:memo)
  end

  def set_item
    @item = PlanSchedule.find(params[:id])
  end

  def build_item
    @item = @plan.plan_schedules.build(schedule: Schedule.find(params[:schedule_id]))
  end

  def set_plan
    @plan = @item ? @item.plan : Plan.find(params[:plan_id])
  end

  def check_user_owns_plan
    render status: :bad_request, body: nil if @plan.nil?
    render status: :forbidden, body: nil unless @user.plans.include?(@plan)
  end

  def check_item_belongs_to_event
    render status: :not_found, body: nil unless @item.schedule.track.event == @event
  end
end
