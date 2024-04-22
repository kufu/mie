# frozen_string_literal: true

require 'rqrcode'

module QRcode
  extend ActiveSupport::Concern

  def url_to_svg_qrcode(url:, color: '000', shape_rendering: 'crispEdges', module_size: 11)
    qrcode = RQRCode::QRCode.new(url)

    qrcode.as_svg(
      color:,
      shape_rendering:,
      module_size:,
      standalone: true,
      use_path: true
    )
  end
end
