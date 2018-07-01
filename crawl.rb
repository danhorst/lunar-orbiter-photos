#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'
require 'JSON'
require 'URI'

module Crawler
  IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'
  STRUCTURE_CACHE_FILE='structure.json'

  def self.call
    list_images
  end

  def self.fetch_structure
    frames = list_frames(missions: list_content)
    JSON.pretty_generate(frames)
  end

  def self.structure_paths(input_file: STRUCTURE_CACHE_FILE)
     if File.exist? input_file
       input = File.read input_file
       structure = JSON.parse(input)
     else
       structure = fetch_structure
     end
     frame_urls = []
     structure.each_pair do |mission, frames|
       frames.each do |frame|
         frame_urls << content_url(mission: mission, frame: frame)
       end
     end
     frame_urls
  end

  def self.list_images(paths: self.structure_paths)
    image_urls = []
    paths.each do |path|
      list_content(url: path).each do |image|
        image_urls << URI.join(path, path_from_anchor(image))
      end
    end
    image_urls
  end

  private

  def self.list_content(url: IMG_HOME)
    agent = Mechanize.new
    page = agent.get(url)
    links = page.search('#indexlist a')
    content_links = links[7..-1]
    content_links.reject { |link| link.text.empty? }
  end

  def self.list_frames(missions:)
    frames = Hash.new
    missions.each do |mission|
      mission_path = path_from_anchor(mission)
      url = content_url(mission: mission_path)
      frame_paths = []
      list_content(url: url).each do |frame|
        frame_paths << path_from_anchor(frame)
      end
      frames[mission_path] = frame_paths
    end
    frames
  end

  def self.path_from_anchor(anchor)
    anchor.attribute_nodes.first.value
  end

  def self.content_url(mission:, frame: '', image: '')
    URI.join(IMG_HOME, mission, frame, image)
  end
end

unless File.exist? Crawler::STRUCTURE_CACHE_FILE
  File.write(Crawler::STRUCTURE_CACHE_FILE, Crawler.fetch_structure)
end
puts Crawler.call
