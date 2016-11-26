require 'pry'
class Log < Sequel::Model(:log)
  def self.get_top_locations(top=10, date=Time.now)
    results = []
    query = "SELECT location, COUNT(*) As count FROM public.log WHERE date_trunc('day', created_date) = date_trunc('day','#{date.year}-#{date.month}-#{date.day}'::timestamp) GROUP BY 1 ORDER BY 2 DESC LIMIT #{top}"
    ds = DB.fetch(query)
    ds.each do |row|
      results.push(row)
    end
    results
  end
end
