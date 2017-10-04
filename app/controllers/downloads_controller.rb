class DownloadsController < ApplicationController

  def index
    puts Dir.pwd
    puts Rails.root
  end

  def download
    if params[:url].empty?
      redirect_to root_url, alert: "Youtube URL can't be blank."
    elsif params[:option].nil?
      redirect_to root_url, alert: "Option can't be blank."
    else
      options = { output: '%(title)s.%(ext)s', extract_audio: false }

      if params[:option] == "audio"
        options[:extract_audio] = true
        options[:audio_format] = 'mp3'
      end

      video = YoutubeDL.download params[:url], options
      # render plain: "#{Rails.root}/#{rename(video.filename, options[:extract_audio])}"
      send_file "#{Rails.root}/#{rename(video.filename, options[:extract_audio])}"
    end
  end

  private
  def rename(filename, audio)
    ext = File.extname filename 
    filename = File.basename filename, ext
    ext = audio ? '.mp3' : '.mp4'

    file = filename + ext
    parsed_filename = file.gsub(/ /,"\\ ")
    File.rename parsed_filename, file.gsub(/ /,"-")
    file.gsub(/ /,"-")
  end

end
