class Report
  attr_reader :start_date, :end_date, :locations

  def initialize(start_date, end_date, locations)
    @start_date = start_date
    @end_date = end_date
    @locations = locations
  end

  def run
    locations.each do |location|
      checkins = Checkin.all(:created_at.gte => start_date, :created_at.lt => end_date, :location => location)
      users = checkins.map{|c| c.user}.uniq

      new_customers = 0
      repeat_two_week = 0
      repeat_one_week = 0
      repeat_one_month = 0

      progressbar = ProgressBar.create(:format => '%t %a %B %p%%', :total => users.size)

      users.each do |user|
        user_checkins = Checkin.all(:user => user)
        dates = user_checkins.map{|c| Date.new(c.created_at.year, c.created_at.month, c.created_at.day)}.uniq
        dates.sort!
      if dates[0] >= start_date && dates[0] < end_date
        new_customers += 1
      repeat_two_week += 1 if dates[1] && dates[1] - dates[0] < 14
      repeat_one_week += 1 if dates[1] && dates[1] - dates[0] < 7
      repeat_one_month +=1 if dates[1] && dates[1] - dates[0] < 30
      end
      progressbar.increment
      end

      puts "Location: #{location}"
      puts "# of total customers: #{users.count}"
      puts "# of new customers: #{new_customers}"
      puts "# of repeat customers in one week: #{repeat_one_week}"
      puts "# of repeat customers in two weeks: #{repeat_two_week}"
      puts "# of repeat customers in one month: #{repeat_one_month}"
    end
  end
end
