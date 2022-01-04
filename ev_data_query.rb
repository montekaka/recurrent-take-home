require 'csv'
require 'set'

class EvReport
  def initialize
  end

  def charged_above file_path, charge
    if charge && file_path
      data = read_data(file_path)

      # use Set data charged    
      # this argument should be a decimal, for example 0.33 will be passed to indicate 33%.      
      result = Set.new
      data.each do |record|
        line = record.to_h
        if line["charge_reading"].to_f >= charge
          result.add(record.to_h["vehicle_id"])
        end
      end

      return result.length
    else
      return nil
    end
  end

  def average_daily_miles file_path, vehicle_id

    if file_path == nil || vehicle_id == nil
      return nil
    end

    data = read_data(file_path)
    
    total_miles = 0
    total_days = 0

    data.each do |record|
      line = record.to_h
      if line["vehicle_id"] == vehicle_id
        total_miles += line['range_estimate'].to_f
        total_days += 1
      end
    end

    if total_days > 0
      return total_miles / total_days
    else
      return 0
    end
  end  

  private
  def read_data file_path
    data = CSV.read(file_path, headers: true)
  end
end

ev_report = EvReport.new
# puts ev_report.charged_above 0.3
puts ev_report.average_daily_miles('ev_data.csv', 'cat-car') 