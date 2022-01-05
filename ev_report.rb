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

    date_from = nil
    date_to = nil

    odometer_from = 0
    odometer_to = 0
    
    total_miles = 0
    total_days = 0

    data.each do |record|
      line = record.to_h
      if line["vehicle_id"] == vehicle_id
        total_miles += line['range_estimate'].to_f
        if date_from == nil || (date_from != nil && Date.parse(line['created_at']) < date_from)
          date_from = Date.parse(line['created_at'])
        end        

        if date_to == nil || (date_to != nil && Date.parse(line['created_at']) > date_to)
          date_to = Date.parse(line['created_at'])
        end

        if odometer_from == 0 || line['odometer'].to_f < odometer_from
          odometer_from = line['odometer'].to_f
        end

        if odometer_to == 0 || line['odometer'].to_f > odometer_to
          odometer_to = line['odometer'].to_f
        end        
      end
    end

    total_days = (date_to - date_from) + 1
    total_miles = (odometer_to - odometer_from).to_f

    if total_days > 0
      return total_miles / total_days
    else
      return 0
    end
  end  

  private

  def read_data file_path
    data = []
    begin
      data = CSV.read(file_path, headers: true)
    rescue => error
      p error.message
    end

    return data
  end
  
end