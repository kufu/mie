# frozen_string_literal: true

class PlansController < ApplicationController
  protect_from_forgery

  def page
    @ogpstr =
      '<meta property="og:title" content="' + @plan.title + '">' +
      '<meta property="og:site_name" content="RubyKaigi 2022 Schedule.select powerd by SmartHR">' +
      '<meta property="og:description" content="' + @plan.description + '">' +
      '<meta property="og:url" content="' + request.protocol + request.host_with_port + '/2022/plans/' + @plan.id + '">' +
      '<meta property="og:image" content="' + request.protocol + request.host_with_port + '/2022/api/plans/' + @plan.id + '/ogp?h=' + Digest::MD5.hexdigest(@plan.description) + '" />' +
      '<meta property="og:type" content="website">' +
      '<meta name="twitter:card" content="summary_large_image"/>' +
      "<title>#{@plan.title} | RubyKaigi 2022 Schedule.select</title>"
  end

  private

  # duplicate
  def set_plan
    @plan = Plan.find(params[:id] || params[:plan_id])
    raise ActiveRecord::RecordNotFound if @plan.user != @user && !@plan.public?
  end
end
