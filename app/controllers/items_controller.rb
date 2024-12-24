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

    if request.format.turbo_stream?
      set_attributes_for_turbo_stream
      render 'update'
    else
      redirect_to event_plan_path(@plan, event_name: @event.name)
    end
  end

  def update
    @item.update!(item_params)
    render 'schedules/_card', locals: { schedule: @item.schedule, mode: :plan, inactive: false }
  end

  def destroy
    @item.destroy!
    @plan.update!(initial: false)

    case params[:mode]
    when 'schedule'
      set_attributes_for_turbo_stream
      render 'update'
    when 'plan'
      redirect_to event_plan_path(@plan, event_name: @event.name)
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

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def set_attributes_for_turbo_stream
    @schedules = @event.schedules.includes(:speakers, :track).order(:start_at)
    @schedule_table = Schedule::Tables.new(@schedules)

    @row, @track_list = catch(:abort) do
      @schedule_table.days.each do |day|
        @table = @schedule_table[day]
        @table.rows.each do |row|
          throw :abort, [row, @table.track_list] if row.schedules.map(&:id).include?(@item.schedule.id)
        end
      end
    end

    return unless @user.profile

    @friends_schedules_map = @user.profile.friend_profiles.to_h do |profile|
      [profile.id, profile.user.plans.find_by(event: @event)&.plan_schedules&.map(&:schedule_id) || []]
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
