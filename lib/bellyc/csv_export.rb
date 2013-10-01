class CSVExport
  attr_reader :start_date, :end_date, :filename, :checkins, :users, :visits

  def initialize(start_date, end_date, filename)
    @start_date = start_date
    @end_date = end_date
    @filename = filename
    @checkins = Checkin.all(:created_at => start_date..end_date)
    @users = @checkins.map{|c| c.user}.uniq
    @visits = {}
  end

  def run
    puts "Compiling Users..."
    get_user_visits
    generate_csv
  end

  def get_user_visits
    progressbar1 = ProgressBar.create(:format => '%t %a %B %p%%', :total => users.size)
    users.each do |user|
      checkins_for_user = checkins.select{|c| c.user == user}
      dates_of_checkins = checkins_for_user.map{|c| Date.new(c.created_at.year, c.created_at.month, c.created_at.day)}.uniq
      dates_of_checkins.sort!
      visits[user] = dates_of_checkins
      progressbar1.increment
    end
  end

  def generate_csv
    CSV.open(filename , "w") do |csv|
      puts "Generating CSV:"
      progressbar = ProgressBar.create(:format => '%t %a %B %p%%', :total => users.size)
      csv << ["Username", "First Visit Date"] + (start_date..end_date).map{|d| d.strftime("%b-%d")}
      users.each do |user|
        date_range = (start_date..end_date).map{|d| d}
        boolean_array = date_range.map{|d| visits[user].include?(d) ? 1: 0}
        csv << [user] + [first_visit_date(user)] +  boolean_array
        progressbar.increment
      end
    end
  end

  def first_visit?(user, start_date, end_date)
    visits = Checkin.all(:user => user).map { |c| c.created_at }.uniq.sort
    visits[0] >= start_date && visits[0] <= end_date ? 1 : 0
  end

  def first_visit_date(user)
    visits = Checkin.all(:user => user).map { |c| c.created_at }.uniq.sort
    visits[0].strftime('%Y-%m-%d')
  end
end
