require 'minitest/autorun'
require_relative "ev_report"

class EvReportTest < Minitest::Test
  def test_charged_above
    ev_report = EvReport.new("./test_data/ev_data_1.csv")
    res = ev_report.charged_above(0.7)
    assert_equal(2, res, "charged_above 0.7 must equal 2")

    res = ev_report.charged_above(0.2)
    assert_equal(3, res, "charged_above 0.7 must equal 3")
  end

  def test_average_daily_miles
    ev_report = EvReport.new("./test_data/ev_data_1.csv")
    res = ev_report.average_daily_miles("cat-car")
    assert_equal(0, res, "average_daily_miles for cat-car must equal 0")

    res = ev_report.average_daily_miles("hamster-car")
    assert_equal(1, res, "average_daily_miles for cat-car must equal 1")
  end  

  def test_read_csv
    ev_report = EvReport.new("./test_data/ev_data_1.csv")
    assert_equal(6, ev_report.data.length, "csv file row must equal 6")

    ev_report = EvReport.new("./test_data/ev_data_2.csv")
    assert_equal(0, ev_report.data.length, "wrong csv file path should return 0")    
  end

end