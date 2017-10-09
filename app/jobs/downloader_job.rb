class DownloaderJob < ApplicationJob
  queue_as :default

  def perform(url, current_user, options)
    video = YoutubeDL.download url, options
    file = parse_filename(video.filename, options)
    File.rename Rails.root + file[0], File.join(Rails.root, 'public', file[1])
  end

  after_perform do |job|
    url = job.arguments.first
    filename = YoutubeDL::Runner.new(url, get_filename: true, output: '%(title)s.%(ext)s').run
    file = parse_filename(filename, job.arguments.last)
    data = { url: file[1], status: 'finished' }
    ActionCable.server.broadcast "download_#{job.arguments[1]}", data
  end

  private
  def parse_filename(filename, options)
    ext = File.extname(filename)
    filename = File.basename(filename, ext)
    ext = options[:extract_audio] ? '.mp3' : '.mp4'
    file = filename + ext
    [file, file.gsub(/ /,"-")]
  end

end
