require 'simplecov'
SimpleCov.start

require 'mysql2'
require 'pry'
require 'minitest/autorun'
require_relative 'location'


class LocationTest < Minitest::Test

  def setup
    @client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "photo_db_test")
    Location.db_name = 'photo_db_test'
  end

  def teardown
    clear_locations
  end

  def test_location_can_be_initialized
    location = Location.new latitude: 45.8291, longitude: 75.8291
    assert_equal 45.8291, location.latitude
    assert_equal 75.8291, location.longitude
  end

  def test_get_location
    Location.create latitude: 45.8291, longitude: 75.8291
    location = Location.get 1
    assert_equal 45.8291, location.latitude
    assert_equal 75.8291, location.longitude
  end

  def test_get_location_with_nonexistent_id
    assert_nil Location.get 99
  end

  def test_location_create 
    location = Location.create latitude: 45.8291, longitude: 75.8291
    assert_equal 45.8291, location.latitude
    assert_equal 75.8291, location.longitude
  end

  def test_location_save
    location = Location.new
    location.latitude = 45.8291
    location.longitude = 75.8291
    location.save
    location2 = location.get location.id
    assert_equal location2.latitude, location.latitude
    assert_equal location2.longitude, location.longitude
  end

  def clear_locations
    @client.query('TRUNCATE locations')
  end

end