require 'mysql2'

class Photo

  # class methods

  def self.db_name
    @db_name ||= 'photo_db'
  end

  def self.db_name=(name)
    @db_name = name
  end

  def self.client
    # this takes a hash of options, almost all of which map directly
    # to the familiar database.yml in rails
    # See http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html
    @client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => self.db_name)
  end

  # class method
  def self.get id
    query = "SELECT * FROM photos WHERE id = #{id}"
    results = client.query(query)
    result = results.first
    return unless results.size > 0
    new(title: result['title'], width: result['width'], height: result['height']).tap do |p|
      p.persisted = true
    end
    # short for Photo.new or self.new
    # new 'My Photo Title'
  end

  def self.create title: '', width: 0, height: 0, path: ''
    new(title: title, width: width, height: height, path: path).tap do |p|
      p.save
    end
  end

  def self.all
    query = "SELECT * FROM photos"
    results = client.query(query)
    results.map do |result|
      new(title: result['title'], width: result['width'], height: result['height']).tap do |p|
        p.persisted = true
      end
    end
  end

  # instance methods

  attr_accessor :title, :height, :width, :path

  attr_reader :id

  attr_writer :persisted

  def initialize title: '', width: 0, height: 0, path: ''
    # instance variable
    @title = title
    @width = width
    @height = height
    @persisted = false
    # self.title = title
  end

  def orientation
    @width > @height ? :Landscape : :Portrait
  end

  def landscape?
    orientation == :Landscape
  end

  def portrait?
    orientation == :Portrait
  end

  def save
    if persisted?
      self.class.client.query("UPDATE photos SET title='#{title}', width=#{width}, height=#{height}, path='#{path}' WHERE id=#{id}")
    else
      self.class.client.query("INSERT INTO photos(title, width, height, path) values('#{title}', #{width}, #{height}, '#{path}')")
      @id = self.class.client.last_id
      @persisted = true
    end
  end

  def delete
    self.class.client.query("DELETE FROM photos WHERE id=#{id}")
  end

  def persisted?
    @persisted
  end

end