#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'
require 'JSON'
require 'URI'

class Crawler
  IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'

  def self.fetch_structure
    crawler = self.new
    frames = crawler.list_frames(missions: crawler.list_content)
    JSON.pretty_generate(frames)
  end

  def self.structure_paths(input_file: 'structure.json')
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
    crawler = self.new
    image_urls = []
    paths.each do |path|
      crawler.list_content(url: path).each do |image|
        image_urls << URI.join(path, path_from_anchor(image))
      end
    end
    image_urls
  end

  def list_content(url: IMG_HOME)
    agent = Mechanize.new
    page = agent.get(url)
    links = page.search('#indexlist a')
    content_links = links[7..-1]
    content_links.reject { |link| link.text.empty? }
  end

  def list_frames(missions:)
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

  def list_images(frames:)
    image_urls = []
    frames.each_pair do |mission, frame_list|
      frame_list.each do |frame|
        frame_url = content_url(mission: mission, frame: frame)
	list_content(url: frame_url).each do |image|
	  image_path = path_from_anchor(image)
	  image_urls << content_url(mission: mission, frame: frame, image: image_path)
	end
      end
    end
    image_urls
  end

  def self.path_from_anchor(anchor)
    anchor.attribute_nodes.first.value
  end

  def path_from_anchor(anchor)
    self.class.path_from(anchor)
  end

  def self.content_url(mission:, frame: '', image: '')
    URI.join(IMG_HOME, mission, frame, image)
  end

  def content_url(**args)
    self.class.content_url(**args)
  end
end

#Crawler.fetch_structure
#puts Crawler.structure_paths
puts Crawler.list_images
