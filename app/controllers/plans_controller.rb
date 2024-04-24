# frozen_string_literal: true

class PlansController < ApplicationController
  include EventRouting
  include ScheduleTable

  before_action :set_plan, except: :create
  before_action :check_user_owns_plan, only: :update

  def show
    @schedules = @plan.schedules
    @plans_table = plans_table(@plan)
  end

  def update
    target = switch_update_type_and_exec

    if plan_add_or_remove? && params[:mode] == 'schedule'
      set_attributes_for_turbo_stream
      render 'update'
    elsif plan_add_or_remove? && params[:mode] == 'plan'
      redirect_to event_plan_path(@plan, event_name: @event.name)
    elsif target
      render 'schedules/_card',
             locals: { schedule: target, mode: params[:edit_memo_schedule_id] ? :plan : :schedule, inactive: false }
    else
      redirect_to event_plan_url(@plan, event_name: @event.name)
    end
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
    add_and_remove_plans if plan_add_or_remove?
    redirect_to event_schedules_path(event_name: @plan.event.name)
  end

  private

  def switch_update_type_and_exec
    if plan_add_or_remove?
      add_and_remove_plans
    elsif params[:edit_memo_schedule_id]
      edit_memo
    elsif params[:plan][:description]
      edit_description
    elsif params[:plan][:public]
      edit_password_and_visibility
    elsif params[:plan][:title]
      edit_title
    else
      head :bad_request
    end
  end

  def plan_params
    params.require(:plan).permit(:title, :description, :public, :initial)
  end

  def plan_add_or_remove?
    if params[:plan]
      params[:plan][:add_schedule_id] || params[:plan][:remove_schedule_id]
    else
      params[:add_schedule_id] || params[:remove_schedule_id]
    end
  end

  def redirect_path_with_identifier(target)
    identifier = target&.start_at&.strftime('%Y-%m-%d')
    (request.referer || schedules_path) + (identifier ? "##{identifier}" : '')
  end

  def set_plan
    @plan = Plan.on_event(@event).find(params[:id] || params[:plan_id])
    raise ActiveRecord::RecordNotFound if @plan.user != @user && !@plan.public?
  rescue StandardError => e
    @plan ||= Plan.new
    raise e
  end

  def add_and_remove_plans
    ret = nil
    add_id = params[:add_schedule_id] || params.dig(:plan, :add_schedule_id)
    remove_id = params[:remove_schedule_id] || params.dig(:plan, :remove_schedule_id)
    ActiveRecord::Base.transaction do
      ret = add_plan(add_id) if add_id
      ret = remove_plan(remove_id) if remove_id
    end
    ret
  end

  def add_plan(id)
    ps = @plan.plan_schedules.build(schedule: Schedule.find(id))
    if @plan.valid?
      ps.save!
    else
      flash[:error] = @plan.errors.messages[:schedules]
      redirect_to event_schedules_path(event_name: @plan.event.name) && return
    end
    @plan.update!(initial: false)
    ps.schedule
  end

  def remove_plan(id)
    schedule = Schedule.find(id)
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
    @plan.update!(description: params[:plan][:description])
    nil
  end

  def check_user_owns_plan
    return render :bad_request if @plan.nil?
    return render :bad_request unless @user.plans.include?(@plan)
  end

  def edit_password_and_visibility
    @plan.password = params[:plan][:password] if params[:plan][:password] != ''
    @plan.public = params[:plan][:public] == 'true'
    @plan.save!
    nil
  end

  def edit_title
    @plan.update(title: params[:plan][:title])
    nil
  end

  def set_attributes_for_turbo_stream
    @schedules = @event.schedules.includes(:speakers, :track).order(:start_at)
    @schedule_table = Schedule::Tables.new(@schedules)

    target_schedule_id = params[:add_schedule_id] ||
                         params.dig(:plan, :add_schedule_id) ||
                         params[:remove_schedule_id] ||
                         params.dig(:plan, :remove_schedule_id)

    @row, @track_list = catch(:abort) do
      @schedule_table.days.each do |day|
        table = @schedule_table[day]
        table.rows.each do |row|
          throw :abort, [row, table.track_list] if row.schedules.map(&:id).include?(target_schedule_id)
        end
      end
    end
  end
end
