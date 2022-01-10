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

  def drove_nowhere query_date_str
    # query_date_time = DateTime.parse(query_date_str).to_time
    query_date = Date.parse(query_date_str)
    
    dicts = {}
    # For each EV, find the nearest date     
    # e.g. dict
    # {
    #   'cat-car': {
    #     "closest_earlier_date": 1000001,
    #     "closest_earlier_date_miles": 2000,
    #     "earliest_same_date": 1000002,
    #     "earliest_same_date_miles": 2000
    #     "latest_same_date": 1000002,
    #     "latest_same_date_miles": 2000    
    #     "closest_later_date": 1000003,
    #     "closest_later_date_miles": 2001        
    #   }
    # }

    # 1/1/2022....1/3/2022....1/5/2022....1/8/2022
    # ..1000........1000........1000........4000
    #                           2000

    # cat-car, 1/7/2022

    # 1/1/2022 {"closest_earlier_date": 1/1/2022, "latest_same_date": null, "closest_later_date": 1/1/2022}
    # 1/2/2022 {"closest_earlier_date": 1/2/2022, "latest_same_date": null, "closest_later_date": 1/2/2022}
    # 1/3/2022 {"closest_earlier_date": 1/3/2022, "latest_same_date": null, "closest_later_date": 1/3/2022}
    # 1/5/2022 {"closest_earlier_date": 1/5/2022, "latest_same_date": null, "closest_later_date": 1/5/2022}
    # 1/5/2022 
    # 1/8/2022 {"closest_earlier_date": 1/5/2022, "latest_same_date": null, "closest_later_date": 1/8/2022}
    
    # vehicle_id
    # created_at
    # odometer

    @data.each do |record|
      vehicle_id = record["vehicle_id"]
      created_at = record["created_at"]
      odometer = record["odometer"]
      vehicle = dicts[vehicle_id]
      if vehicle == nil
        # add a new one
        if Date.parse(created_at) == query_date
          {
            "closest_earlier_date": nil,
            "closest_earlier_date_miles": nil,
            "closest_later_date": nil,
            "closest_later_date_miles": nil,                    
            "earliest_same_date": created_at,
            "earliest_same_date_miles": odometer,
            "latest_same_date": created_at,
            "latest_same_date_miles": odometer    
          }
        elsif Date.parse(created_at) < query_date
          {
            "closest_earlier_date": created_at,
            "closest_earlier_date_miles": odometer,
            "closest_later_date": nil,
            "closest_later_date_miles": nil,                    
            "earliest_same_date": nil,
            "earliest_same_date_miles": nil,
            "latest_same_date": nil,
            "latest_same_date_miles": nil    
          }
        else 
          {
            "closest_earlier_date": nil,
            "closest_earlier_date_miles": nil,
            "closest_later_date": created_at,
            "closest_later_date_miles": odometer,                    
            "earliest_same_date": nil,
            "earliest_same_date_miles": nil,
            "latest_same_date": nil,
            "latest_same_date_miles": nil    
          }          
        end
      else
        if Date.parse(created_at) == query_date
          if vehicle["earliest_same_date"] == nil
            # if DateTime.parse(created_at) < DateTime.parse(vehicle[closest_earlier_date])
            vehicle["earliest_same_date"] = created_at
            vehicle["earliest_same_date_miles"] = odometer
            vehicle["latest_same_date"] = created_at
            vehicle["latest_same_date_miles"] = odometer            
          else
            if DateTime.parse(created_at) < DateTime.parse(vehicle["earliest_same_date"])
              vehicle["earliest_same_date"] = created_at
              vehicle["earliest_same_date_miles"] = odometer
            end

            if DateTime.parse(created_at) > DateTime.parse(vehicle["latest_same_date"])
              vehicle["latest_same_date"] = created_at
              vehicle["latest_same_date_miles"] = odometer
            end
          end          
        elsif Date.parse(created_at) < query_date
          if vehicle["closest_earlier_date"] == nil || DateTime.parse(created_at) > DateTime.parse(vehicle["closest_earlier_date"])
            vehicle["closest_earlier_date"] = created_at
            vehicle["closest_earlier_date_miles"] = odometer
          end
        else
          if vehicle["closest_later_date"] == nil || DateTime.parse(created_at) < DateTime.parse(vehicle["closest_later_date"])
            vehicle["closest_later_date"] = created_at
            vehicle["closest_later_date_miles"] = odometer            
          end
        end
        
      end
    end

    vehicles = dicts.keys
    result = 0
    vehicles.each do |vehicle|
      if vehicle_moved vehicle
        result += 1
      end
    end
    
    return result
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

  def vehicle_moved data
    # ---|---|-----|----|----
    #    1   1     2    3

    if data
    return false
  end
  
end