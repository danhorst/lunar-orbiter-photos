#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'

class Crawler
  IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'

  def initialize
    missions = list_folders
    binding.pry
  end

  def list_folders(url: IMG_HOME)
    agent = Mechanize.new
    page = agent.get(url)
    links = page.search('#indexlist a')
    content_links = links[7..-1]
    content_links.reject { |link| link.text.empty? }
  end
end

Crawler.new
