class DownloaderJob < ApplicationJob
  queue_as :default

  def perform(url, options)
    video = YoutubeDL.download url, options
    file = parse_filename(video.filename, options)
    File.rename Rails.root + file[0], file[1]
  end

  after_perform do |job|
    url = job.arguments.first
    filename = YoutubeDL::Runner.new(url, get_filename: true, output: '%(title)s.%(ext)s').run
    file = parse_filename(filename, job.arguments.last)
    data = { url: file[1], status: 'finished' }
    ActionCable.server.broadcast 'download_channel', data
  end

  private
  def parse_filename(filename, options)
    ext = File.extname(filename)
    filename = File.basename(filename, ext)
    ext = options[:extract_audio] ? '.mp3' : '.mp4'
    file = filename + ext
    [file, File.join(Rails.root, 'public', file.gsub(/ /,"-"))]
  end

end
