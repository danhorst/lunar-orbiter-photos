#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'
require 'json'
require 'uri'

class Crawler
  IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'

  def self.logger(output: STDOUT, level: Logger::DEBUG)
    @@logger ||= Logger.new(output)
  end

  module Content
    def list(url: Crawler::IMG_HOME)
      Crawler.logger.info("List links for: #{url}")
      agent = Mechanize.new
      page = agent.get(url)
      links = page.search('#indexlist a')
      content_links = links[7..-1]
      content_links.reject { |link| link.text.empty? }
      Crawler.logger.debug(content_links)
      content_links
    end
    module_function :list

    def path_from_anchor(anchor)
      anchor.attribute_nodes.first.value
    end
    module_function :path_from_anchor

    def url(mission:, frame: '', image: '')
      URI.join(IMG_HOME, mission, frame, image)
    end
    module_function :url
  end

  def self.fetch_structure
    logger.info('#fetch_structure')
    crawler = self.new
    frames = crawler.list_frames(missions: Crawler::Content.links)
    JSON.pretty_generate(frames)
  end

  def self.structure_paths(input_file: 'structure.json')
    logger.info('#structure_paths')
    if File.exist? input_file
      logger.debug("Input file: #{input_file}")
      input = File.read input_file
      structure = JSON.parse(input)
    else
      logger.debug('No input file found')
      structure = fetch_structure
    end
    frame_urls = []
    structure.each_pair do |mission, frames|
      frames.each do |frame|
        logger.debug("Finding URL for #{mission}, #{frame}")
        frame_urls << Crawler::Content.url(mission: mission, frame: frame)
      end
    end
    frame_urls
  end

  def self.list_images(paths: self.structure_paths)
    logger.info('#list_images')
    image_urls = []
    paths.each do |path|
      Crawler::Content.list(url: path).each do |image|
        logger.info("Image URLs for: #{path}")
        image_urls << URI.join(path, Crawler::Content.path_from_anchor(image))
      end
    end
    logger.debug(image_urls)
    image_urls
  end

  def list_frames(missions:)
    self.class.logger.info('#list_frames')
    agent = Mechanize.new
    frames = Hash.new
    missions.each do |mission|
      mission_path = Crawler::Content.path_from_anchor(mission)
      url = Crawler::Content.url(mission: mission_path)
      frame_paths = []
      Crawler::Content.list(url: url).each do |frame|
        frame_paths << Crawler::Content.path_from_anchor(frame)
      end
      frames[mission_path] = frame_paths
    end
    frames
  end

  def list_images(frames:)
    self.class.logger.info('#list_images')
    image_urls = []
    frames.each_pair do |mission, frame_list|
      frame_list.each do |frame|
        frame_url = Crawler::Content.url(mission: mission, frame: frame)
        Crawler::Content.list(url: frame_url).each do |image|
          image_path = Crawler::Content.path_from_anchor(image)
          self.class.logger.debug(image_path)
          image_urls << Crawler::Content.url(mission: mission, frame: frame, image: image_path)
        end
      end
    end
    image_urls
  end
end

#Crawler.fetch_structure
#puts Crawler.structure_paths
puts Crawler.list_images
