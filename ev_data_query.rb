require 'optparse'
require_relative "ev_report"

ev_report = EvReport.new

csv_file_path, method, *args = ARGV
puts ev_report.send(method, csv_file_path, *args)


