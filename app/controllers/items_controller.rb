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

    set_schedule_table
    set_friends_schedules_map

    if turbo_frame_request?
      render
    else
      redirect_to event_path(@event.name)
    end
  end

  def update
    @item.update!(item_params)
    redirect_to event_path(@event.name)
  end

  def destroy
    @item.destroy!
    @plan.update!(initial: false)

    set_schedule_table
    set_friends_schedules_map

    if turbo_frame_request?
      render 'create'
    else
      redirect_to event_path(@event.name)
    end
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

  def set_schedule_table
    @schedule_table = Schedule::Tables.from_event(@event)
    @row = @schedule_table.tables.map(&:rows).flatten.find { _1.schedules.include?(@item.schedule) }
  end

  def set_friends_schedules_map
    # TODO: extract to concern, same logic in the schedules_controller
    @friends_schedules_map = @user&.profile&.friend_profiles.to_h do |profile|
      [profile.id, profile.user.plans.find_by(event: @event)&.plan_schedules&.map(&:schedule_id) || []]
    end
  end
end
