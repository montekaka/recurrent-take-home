require 'minitest/autorun'
require_relative "ev_report"

class EvReportTest < MiniTest::Unit::TestCase
  

  describe "test charged_above" do
    it "must return 2" do
      def test_charged_above
        ev_report = EvReport.new
        count = ev_report.charged_above("./test_data/ev_data_1.csv", 0.7)
        assert_equal(count, 2)
      end
    end
  end

end