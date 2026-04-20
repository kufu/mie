# frozen_string_literal: true

module ApplicationHelper
  PWA_VERSION = '2026-2'.freeze

  def current_path?(path)
    request.path == path
  end

  def pwa_version
    PWA_VERSION
  end

  def versioned_path(path, version: pwa_version)
    separator = path.include?('?') ? '&' : '?'
    "#{path}#{separator}v=#{ERB::Util.url_encode(version)}"
  end
end
