require 'minitest/autorun'
require_relative "ev_report"

class EvReportTest < Minitest::Test
  def test_charged_above
    ev_report = EvReport.new
    res = ev_report.charged_above("./test_data/ev_data_1.csv", 0.7)
    assert_equal(2, res, "charged_above 0.7 must equal 2")

    res = ev_report.charged_above("./test_data/ev_data_1.csv", 0.2)
    assert_equal(3, res, "charged_above 0.7 must equal 2")
  end

  def test_average_daily_miles
    ev_report = EvReport.new
    res = ev_report.average_daily_miles("./test_data/ev_data_1.csv", "cat-car")
    assert_equal(0, res, "average_daily_miles for cat-car must equal 0")

    res = ev_report.average_daily_miles("./test_data/ev_data_1.csv", "hamster-car")
    assert_equal(1, res, "average_daily_miles for cat-car must equal 1")
  end  

end