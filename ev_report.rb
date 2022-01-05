require 'csv'
require 'set'
require 'date'

class EvReport
  def initialize(file_path)
    @file_path = file_path
    @data = read_data file_path
  end

  def data
    @data
  end

  def charged_above charge
    if charge && charge.to_f >= 0  && charge.to_f <= 1
      # make sure the charge amount exists and is between 0 and 1
      
      # compare each charge read, and add the vehicle id to the result set if the meets the condition
      result = Set.new
      @data.each do |record|
        line = record.to_h
        if line["charge_reading"].to_f >= charge.to_f
          result.add(record.to_h["vehicle_id"])
        end
      end # O(n)

      return result.length
    else
      return 0
    end
  end

  def average_daily_miles vehicle_id
    if vehicle_id == nil
      return nil
    end

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

    @data.each do |record|
      line = record.to_h
      if line["vehicle_id"] == vehicle_id

        record_date = DateTime.parse(line['created_at']).to_time

        if date_from == nil || (date_from != nil && record_date < date_from)
          date_from = record_date
          odometer_from = line['odometer'].to_f
        end        

        if date_to == nil || (date_to != nil && record_date > date_to)
          date_to = record_date
          odometer_to = line['odometer'].to_f
        end     
      end
    end

    total_days = (date_to.to_date - date_from.to_date).to_i + 1 # add 1 to adjust the start date
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