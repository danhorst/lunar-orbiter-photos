#! /usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'mechanize'
require 'logger'
require 'json'
require 'uri'

class Crawler
  IMG_HOME = 'https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'
  STRUCTURE_FILE = 'structure.json'
  URL_LIST = 'image_urls.txt'

  def self.logger(output: $stdout, level: Logger::DEBUG)
    @@logger ||= Logger.new(output)
    @@logger.level = level
    @@logger
  end

  module Content
    module_function

    def list(url: Crawler::IMG_HOME)
      Crawler.logger.info("List links for: #{url}")
      agent = Mechanize.new
      page = agent.get(url)
      links = page.search('#indexlist .indexcolname a')
      content_links = links[2..]
      content_links.reject { |link| link.text.empty? }
      Crawler.logger.debug(content_links.collect { |link| path_from_anchor(link) }.inspect)
      content_links
    end

    def frames(missions:)
      Crawler.logger.info('#list_frames')
      frames = {}
      missions.each do |mission|
        mission_path = path_from_anchor(mission)
        url = url(mission: mission_path)
        frame_paths = []
        list(url: url).each do |frame|
          frame_paths << path_from_anchor(frame)
        end
        frames[mission_path] = frame_paths
      end
      frames
    end

    def path_from_anchor(anchor)
      anchor.attribute_nodes.first.value
    end

    def url(mission:, frame: '', image: '')
      URI.join(IMG_HOME, mission, frame, image)
    end
  end

  def self.fetch_structure(output: STRUCTURE_FILE)
    logger.info('#fetch_structure')
    missions = Crawler::Content.list
    logger.debug missions.inspect
    frames = Crawler::Content.frames(missions: missions)
    logger.debug frames.inspect
    IO.write(output, JSON.pretty_generate(frames))
  end

  def self.structure_paths(input_file: STRUCTURE_FILE)
    logger.info('#structure_paths')
    if File.exist? input_file
      logger.debug("Input file: #{input_file}")
      input = File.read input_file
      structure = JSON.parse(input)
    else
      logger.error("Input file #{input_file} not found. Run Crawler.fetch_structure to generate it.")
      exit
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

  def self.list_images(paths: structure_paths)
    logger.info('#list_images')
    image_urls = []
    paths.each do |path|
      Crawler::Content.list(url: path).each do |image|
        logger.info("Image URLs for: #{path}")
        image_url = URI.join(path, Crawler::Content.path_from_anchor(image))
        logger.debug(image_url)
        image_urls << image_url.to_s
      end
    end
    image_urls
  end
end

Crawler.fetch_structure unless File.exist? Crawler::STRUCTURE_FILE
IO.write(Crawler::URL_LIST, Crawler.list_images.join("\n"))
