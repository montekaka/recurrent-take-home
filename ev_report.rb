require 'csv'
require 'set'

class EvReport
  def initialize
  end

  def charged_above file_path, charge
    if file_path && charge && charge.to_f >= 0  && charge.to_f <= 1
      # make sure user entered file_path, and charge amount exists and is between 0 and 1

      data = read_data(file_path)    
      
      # compare each charge read, and add the vehicle id to the result set if the meets the condition
      result = Set.new
      data.each do |record|
        line = record.to_h
        if line["charge_reading"].to_f >= charge.to_f
          result.add(record.to_h["vehicle_id"])
        end
      end # O(n)

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

    # calculate the average daily miles 
    # 1. get the total miles for the given vehicle
    # 2. get the total days (of record) for the give vehicle
    # 3. use total miles / total days to calculate average
    
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