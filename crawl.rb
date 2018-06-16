#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'
require 'URI'

class Crawler
  IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'

  def initialize
    missions = list_folders
    frames = list_frames(missions: missions)
  end

  def list_folders(url: IMG_HOME)
    agent = Mechanize.new
    page = agent.get(url)
    links = page.search('#indexlist a')
    content_links = links[7..-1]
    content_links.reject { |link| link.text.empty? }
  end

  def list_frames(missions: missions)
    frames = Hash.new
    missions.each do |mission|
      mission_path = path_from_anchor(mission)
      url = content_url(mission: mission_path)
      frame_paths = []
      list_folders(url: url).each do |frame|
        frame_paths << path_from_anchor(frame)
      end
      frames[mission_path] = frame_paths
    end
    frames
  end

  def path_from_anchor(anchor)
    anchor.attribute_nodes.first.value
  end

  def content_url(mission:, frame: '')
    URI.join(IMG_HOME, mission, frame)
  end
end

Crawler.new
