class Parser
	attr_reader :page

	def initialize(page)
		@page = page
	end

	def table_rows
		self.page.search('tr').drop(1)
	end

	def row_to_hash(row)
		hash = {}
		hash[:checkin_id] = self.checkin_id(row)
		hash[:created_at] = self.get_date(row)
		hash[:user] = self.users(row)
		hash[:location] = self.locations(row)
		hash[:points] = self.points(row)
		hash

	end

	def checkin_id(row)
		row.attributes["checkin"].value.to_i
	end

	def get_date(row)
		datetime_string = row.search('td.created_at').text +  " -6"
		DateTime.strptime(datetime_string, '%a, %b %d, %y.  %l:%M%p %z')
	end

	def users(row)
		row.search('td.user').text
	end

	def locations(row)
		loc = row.search('td.business a')[0].attributes["href"].value.match(/\d+/)[0]
		loc.to_i
	end

	def points(row)
		row.search('td.points').text.to_i
	end
end
