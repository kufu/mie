# frozen_string_literal: true

module Plans
  class OgpsController < ApplicationController
    include EventRouting
    before_action :set_plan

    def show
      send_data IMGKit.new(get_html(@plan.description), quality: 20, width: 800).to_img(:png), type: 'image/png',
                                                                                               disposition: 'inline'
    end

    private

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end

    def get_html(body)
      <<~HTML
            <!DOCTYPE html>
        <html lang="ja">
          <head>
        	<meta charset="UTF-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
        	<style>
            *,*::before,*::after{box-sizing:border-box}body,h1,h2,h3,h4,p,figure,blockquote,dl,dd{margin:0}ul[role="list"],ol[role="list"]{list-style:none}html:focus-within{scroll-behavior:smooth}body{min-height:100vh;text-rendering:optimizeSpeed;line-height:1.5}a:not([class]){text-decoration-skip-ink:auto}img,picture{max-width:100%;display:block}input,button,textarea,select{font:inherit}@media(prefers-reduced-motion:reduce){html:focus-within{scroll-behavior:auto}*,*::before,*::after{animation-duration:.01ms !important;animation-iteration-count:1 !important;transition-duration:.01ms !important;scroll-behavior:auto !important}}
        	  @charset "UTF-8";
        	  html {
              font-family: 'Noto Sans CJK JP', 'Noto Color Emoji', 'Noto Emoji', sans-serif;
        		  -ms-text-size-adjust: 100%;
        		  -webkit-text-size-adjust: 100%;
        	  }
            * {
              box-sizing: border-box;
            }
            .ogp-frame {
        		  width: 1200px;
              height: 630px;
              overflow: hidden;
              background: no-repeat center url(data:image/png;#{ogp_background_image});
              padding: 44px 34px 240px 64px;
              line-height: 1.5;
              font-size: 58px;
              color: white;
              word-break: break-all;
            }
            .ogp-body {
              width: 100%;
              height: 100%;
              overflow-y: hidden;
              display: -webkit-box;
              -webkit-line-clamp: 4;
              -webkit-box-orient: vertical;
              padding: 0 10px 0 0;
            }
        #{'    '}
            .ogp-body::-webkit-scrollbar {  /* Chrome, Safari 対応 */
                display:none;
            }
        #{'	  '}
        	</style>
          </head>
          <body><div class="ogp-frame"><div class="ogp-body">#{ERB::Util.h(body)}</div></div></body></html>
      HTML
    end

    def ogp_background_image
      "data:image/png;base64,#{Base64.strict_encode64(File.read("public/#{@event.name}/ogp.png", mode: 'rb'))}"
    end
  end
end
