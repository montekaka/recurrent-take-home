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
  end

  def test_drove_nowhere
    ev_report = EvReport.new("./test_data/ev_data_2.csv")

    res = ev_report.drove_nowhere("2019-09-21")
    assert_equal(0, res, "drove_nowhere for 2019-09-21 must equal 0")
        
    res = ev_report.drove_nowhere("2020-01-01")
    assert_equal(0, res, "drove_nowhere for 2020-01-01 must equal 0")
    
    res = ev_report.drove_nowhere("2020-01-02")
    assert_equal(0, res, "drove_nowhere for 2020-01-02 must equal 1")    

    res = ev_report.drove_nowhere("2020-01-03")
    assert_equal(0, res, "drove_nowhere for 2020-01-03 must equal 1")

    res = ev_report.drove_nowhere("2020-01-04")
    assert_equal(0, res, "drove_nowhere for 2020-01-04 must equal 1")  
    
    res = ev_report.drove_nowhere("2020-01-05")
    assert_equal(0, res, "drove_nowhere for 2020-01-05 must equal 0")

    res = ev_report.drove_nowhere("2020-01-06")
    assert_equal(0, res, "drove_nowhere for 2020-01-06 must equal 0")
    
    res = ev_report.drove_nowhere("2020-01-07")
    assert_equal(0, res, "drove_nowhere for 2020-01-07 must equal 0")    

    res = ev_report.drove_nowhere("2020-02-21")
    assert_equal(0, res, "drove_nowhere for 2020-02-21 must equal 0")        
  end

end