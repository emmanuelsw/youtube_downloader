class DownloadsController < ApplicationController

  def index
  end

  def download
    if params[:url].empty?
      redirect_to root_url, alert: "Youtube URL can't be blank."
    elsif params[:option].nil?
      redirect_to root_url, alert: "Option can't be blank."
    else
      options = { output: '%(title)s.%(ext)s' }

      if params[:option] == "audio"
        options[:extract_audio] = true
        options[:audio_format] = 'mp3'
      end

      DownloaderJob.perform_later(params[:url], cookies[:yd_session], options)
      head :no_content
    end
  end

end
