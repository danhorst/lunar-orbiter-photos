#! /usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'

IMG_HOME='https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/'

agent = Mechanize.new
page = agent.get(IMG_HOME)

links = page.search('#indexlist a')
content_links = links[7..-1]
links_with_targets = content_links.reject { |link| link.text.empty? }

binding.pry
