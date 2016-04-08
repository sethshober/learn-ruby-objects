require 'simplecov'
SimpleCov.start

require 'mysql2'
require 'pry'
require 'minitest/autorun'
require_relative 'photo'


class PhotoTest < Minitest::Test

  def setup
    @client ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "photo_db_test")
    Photo.db_name = 'photo_db_test'
  end

  def teardown
    clear_photos
  end

  def test_title_can_be_assigned
    p = Photo.new
    p.title = 'My Photo Title'
    assert_equal 'My Photo Title', p.title
  end

  def test_title_can_be_initialized
    p = Photo.new title: 'My Photo Title'
    assert_equal 'My Photo Title', p.title
  end

  def test_get_photo
    Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    p = Photo.get 1
    assert_equal 'test', p.title
    assert_equal 0, p.height
    assert_equal 0, p.width
    #assert_equal 'the.path', p.path
  end

  def test_get_photo_with_nonexistent_id
    assert_nil Photo.get 99
  end

  def test_photo_create 
    p = Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    assert_equal 'test', p.title
    assert_equal 0, p.height
    assert_equal 0, p.width
    #assert_equal 'the.path', p.path
  end

  def test_photo_save
    p = Photo.new
    p.title = 'my title'
    p.height = 5
    p.width = 8
    #p.path = 'my.path'
    p.save
    p2 = Photo.get p.id
    assert_equal p2.title, p.title
    assert_equal p2.height, p.height
    assert_equal p2.width, p.width
    #assert_equal p2.path, p.path
  end

  def test_width_equal_to
    p = Photo.new width: 5
    assert_equal 5, p.width
  end

  def test_height_equal_to
    p = Photo.new width: 5, height: 10
    assert_equal 10, p.height
  end

  def test_orientation
    p = Photo.new width: 10, height: 4
    assert_equal :Landscape, p.orientation
  end

  def test_landscape_predicate
    p = Photo.new width: 10, height: 4
    assert p.landscape?
  end

  def test_portrait_predicate
    p = Photo.new width: 4, height: 10
    assert p.portrait?
  end  

  def test_new_photo_not_persisted
    p = Photo.new
    refute p.persisted?
  end

  def test_get_photo_persisted
    Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    p = Photo.get 1
    assert p.persisted?
  end

  def test_create_photo_persisted
    p = Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    assert p.persisted?, 'expected persisted photo'
  end

  def test_photo_save_persisted
    p = Photo.new
    p.save
    assert p.persisted?
  end

  def test_save_photo_inserts_when_new
    p = Photo.new
    refute p.id
    refute p.persisted?
    p.save
    assert p.id
    assert p.persisted?
  end

  def test_save_photo_update_when_existing
    p = Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    assert p.id
    assert p.persisted?
    assert_equal 'test', p.title
    p.title = 'new title'
    p.save
    p = Photo.get p.id
    assert 'new title', p.title
  end

  def test_delete_photo
    p = Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    refute_nil Photo.get p.id
    p.delete
    assert_nil Photo.get p.id
  end

  def test_get_all_photos
    assert_equal [], Photo.all
    Photo.create title: 'test', height: 0, width: 0, path: 'the.path'
    assert_equal 1, Photo.all.size
  end

  def clear_photos
    @client.query("DELETE FROM photos")
    @client.query("ALTER TABLE photos AUTO_INCREMENT = 1")
  end

end















