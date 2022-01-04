require 'csv'
require 'set'

class EvReport
  def initialize file_path
    @file_path = file_path
    @data = CSV.read(@file_path, headers: true)
  end

  def charged_above charge
    if charge
      # use Set data charged    
      # this argument should be a decimal, for example 0.33 will be passed to indicate 33%.
      result = Set.new
      @data.each do |record|
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

  def average_daily_miles
  end  

  private
  def read_data
    @data = CSV.read(@file_path, headers: true)
  end
end

ev_report = EvReport.new("ev_data.csv")
puts ev_report.charged_above 0.3