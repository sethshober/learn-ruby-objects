require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :username => "root")

db_name = 'photo_db'
if ENV['APP_ENV']
  db_name = "#{db_name}_#{ENV['APP_ENV']}"
end


sql = <<-EOS
  CREATE TABLE IF NOT EXISTS photos
  (
    id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255),
    height INT,
    width INT,
    path VARCHAR(255),
    PRIMARY KEY (id) 
  );
EOS

client.query("CREATE DATABASE IF NOT EXISTS #{db_name}")
client.query("USE #{db_name}")
client.query(sql)