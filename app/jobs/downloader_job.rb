class DownloaderJob < ApplicationJob
  queue_as :default

  def perform(url, options)
    video = YoutubeDL.download url, options

    ext = File.extname video.filename 
    filename = File.basename video.filename, ext
    ext = options[:extract_audio] ? '.mp3' : '.mp4'

    file = filename + ext
    File.rename Rails.root+file, File.join(Rails.root, 'public', file.gsub(/ /,"-"))
  end

end
