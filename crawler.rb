require 'rubygems'
require 'mongoid'
require 'mechanize'
require 'colored'
require 'open-uri'
require 'cgi'

require './node.rb'
require './doctor.rb'

Mongoid.load!("mongoid.yml", :development)

