require 'mysql2'

class Location

  def self.db_name
    @db_name ||= 'photo_db'
  end

  def self.db_name=(name)
    @db_name = name
  end

  attr_accessor :latitude, :longitude

  def initialize latitude:, longitude:
    @latitude = latitude
    @longitude = longitude
  end

  def self.client
    @client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => self.db_name)
  end

end