#!/usr/bin/env ruby
require "mp3info"
require "yaml"

files = Dir.glob(__dir__ + "/../_posts/*")

logo = open(File.join(__dir__, 'logo.png'),'rb').read

files.each do |file|
  puts file

  f = open(file).read

  content = f.split("---").last

  data = YAML.load(f)

  mp3_file = "mp3"
  mp3_file << "/" << data["categories"].sub("season", "s")
  mp3_file << "/e" << data["episode"].to_s.rjust(2, "0")
  mp3_file << ".mp3"

  next unless File.exists? mp3_file

  Mp3Info.open(mp3_file) do |mp3|
    # quick hack to format seconds to time
    data["duration"] = Time.at(mp3.length).gmtime.strftime("%R:%S")
    data["length"] = File.size(mp3_file)

    mp3.tag.title = data["title"]
    mp3.tag.artist = "Stereo Semantics"
    mp3.tag.tracknum = data["episode"].to_i
    mp3.tag.album = "Season #{data["categories"][/\d+/].to_i}"
    mp3.tag2.add_picture(logo)
  end

  # p data
  # p content

  open(file, "w") do |f|
    f << data.to_yaml
    f << "---"
    f << content
  end

end
