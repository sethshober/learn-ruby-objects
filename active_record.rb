require 'mysql2'

class ActiveRecord

  class << self

    attr_accessor :table_name

    def db_name
      @db_name ||= 'photo_db'
    end

    def db_name=(name)
      @db_name = name
    end

    def client
      @client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => db_name)
    end

  end

  attr_reader :id
  attr_writer :persisted

  def persisted?
    @persisted
  end

  def delete
    self.class.client.query("DELETE FROM #{self.class.table_name} WHERE id=#{id}")
  end

end