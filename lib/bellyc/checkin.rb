require 'data_mapper'

class Checkin
  include DataMapper::Resource
  DataMapper.setup(:default, DATABASE)

  property :id, Serial
  property :created_at, DateTime
  property :location, Integer, :index => true
  property :user, String, :index => true
  property :points, Integer
  property :checkin_id, Integer

  validates_uniqueness_of :checkin_id
end

DataMapper.finalize
