require 'optparse'
require_relative "ev_report"

csv_file_path, method, *args = ARGV

ev_report = EvReport.new(csv_file_path)
puts ev_report.send(method, *args)


