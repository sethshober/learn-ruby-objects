require_relative 'active_record'

class Location < ActiveRecord

  self.table_name = 'locations'

  attr_accessor :latitude, :longitude

  def initialize latitude:, longitude:
    @latitude = latitude
    @longitude = longitude
  end

  def self.create latitude:, longitude:
    new(latitude: latitude, longitude: longitude).tap do |location|
      location.save
    end
  end

  def self.get id
    query = "SELECT * FROM locations WHERE id = #{id}"
    results = client.query(query)
    result = results.first
    return unless results.size > 0
    new(latitude: result['latitude'], longitude: result['longitude']).tap do |location|
      location.persisted = true
    end
  end

  def save
    if persisted?
      self.class.client.query("UPDATE locations SET latitude='#{latitude}', longitude=#{longitude} WHERE id=#{id}")
    else
    self.class.client.query("INSERT INTO locations(latitude, longitude) values(#{latitude}, #{longitude})")
      @id = self.class.client.last_id
      @persisted = true
    end
  end

end