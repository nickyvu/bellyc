require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'data_mapper'
require 'dm-core'
require 'dm-postgres-adapter'

class Crawler
	attr_reader :url, :username, :password

	def initialize(url, username, password)
		@url = url
		@username = username
		@password = password
    @duplicate_checkins = 0
	end

  def run
    page = Parser.new(login)
    loop do
      scrape(page)
      break if @duplicate_checkins >= 60
      page = go_to_next(page)
    end
  end

  def login
		agent = Mechanize::new
		agent.ca_file = '/usr/local/etc/openssl/certs/cacert.pem'
		page = agent.get(url)
		page.form.field_with(:name => "user[email]").value = username
		page.form.field_with(:name => "user[password]").value = password
		page = page.form.submit
		page = agent.get("https://www.bellycard.com/partner/chains/14689/checkins")
  end

  def scrape(page)
		rows = page.table_rows
		rows.each do |row|
			hash = page.row_to_hash(row)
			checkin = Checkin.create(hash)
			if checkin.save
				puts "ADDED #{checkin.checkin_id} | #{checkin.created_at.strftime('%mm-%dd-%yy %H:%M')} | #{checkin.user} | #{checkin.location}"
			else
				puts "NOT ADDED #{checkin.checkin_id} | #{checkin.created_at.strftime('%mm-%dd-%yy %H:%M')} | #{checkin.user} | #{checkin.location} | #{checkin.errors.full_messages.join}" 
        @duplicate_checkins += 1
			end 
    end
  end

  def go_to_next(page)
		Parser.new(page.page.links[-2].click)
  end

	def visit_checkins
		agent = Mechanize::new
		agent.ca_file = '/usr/local/etc/openssl/certs/cacert.pem'
		page = agent.get(url)
		page.form.field_with(:name => "user[email]").value = username
		page.form.field_with(:name => "user[password]").value = password
		page = page.form.submit
		page = agent.get("https://www.bellycard.com/partner/chains/14689/checkins")
	end
end
