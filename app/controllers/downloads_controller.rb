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
      options = { output: '%(title)s.%(ext)s' }

      if params[:option] == "audio"
        options[:extract_audio] = true
        options[:audio_format] = 'mp3'
      end

      video = YoutubeDL.download params[:url], options
      send_file rename(video.filename, options[:extract_audio])
    end
  end

  private
  def rename(filename, audio)
    ext = File.extname filename 
    filename = File.basename filename, ext
    ext = audio ? '.mp3' : '.mp4'

    file = filename + ext
    File.rename Rails.root+file, Rails.root+file.gsub(/ /,"-")
    "#{Rails.root}/#{file.gsub(/ /,"-")}"
  end

end
