require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'parslet/rig/rspec'

describe Tc::Duration do
  let(:parser) { Tc::Duration.new }

  context "integer" do
    it "should consume '0'" do
      parser.integer.should parse('0')
    end
  end

  context "mm" do
    it "should consume '00'" do
      parser.mm.should parse('00')
    end

    it "should consume '32'" do
      parser.mm.should parse('32')
    end

    it "should consume '59'" do
      parser.mm.should parse('59')
    end

    it "should not consume '63'" do
      parser.mm.should_not parse('63')
    end

    it "should not consume '123'" do
      parser.mm.should_not parse('123')
    end
  end

  context "min" do
    it "should consume '00'" do
      parser.min.should parse('00')
    end

    it "should consume '63'" do
      parser.min.should parse('63')
    end

    it "should consume '123'" do
      parser.min.should parse('123')
    end
  end

  context "minutes" do
  end

  context "s_minutes" do
    it "should consume 'm'" do
      parser.s_minutes.should parse('m')
    end

    it "should consume 'Min'" do
      parser.s_minutes.should parse('Min')
    end

    it "should consume 'min.'" do
      parser.s_minutes.should parse(' min.')
    end

    it "should consume 'minutes'" do
      parser.s_minutes.should parse(' minutes')
    end

    it "should consume 'mins'" do
      parser.s_minutes.should parse('mins')
    end
  end

  context "m" do
    it "should consume '53m'" do
      parser.m.should parse('53m')
    end

    it "should consume '32 min." do
      parser.m.should parse('32 min.')
    end

    it "should consume '120 minutes'" do
      parser.m.should parse('120 minutes')
    end

    it "should consume '42 Minutes'" do
      parser.m.should parse('42 Minutes')
    end

    it "should consume '58\''" do
      parser.m.should parse('58\'')
    end
  end

  context "hh" do
  end

  context "small_h" do
    it "should consume '01'" do
      parser.small_h.should parse('01')
    end

    it "should consume '0'" do
      parser.small_h.should parse('0')
    end

    it "should consume '2'" do
      parser.small_h.should parse('2')
    end

    it "should not consume '12'" do
      parser.small_h.should_not parse('12')
    end
  end

  context "small_h_m_s" do
    it "should consume '01:09:26 s'" do
      parser.small_h_m_s.should parse('01:09:26 s')
    end

    it "should consume '0:28:46'" do
      parser.small_h_m_s.should parse('0:28:46')
    end
    
    it "should not consume '275:00:00'" do
      parser.small_h_m_s.should_not parse('275:00:00')
    end

    it "should not consume '4:52:12'" do
      parser.small_h_m_s.should_not parse('4:52:12')
    end

  end

  context 's_hours' do
    it "should consume 'h'" do
      parser.s_hours.should parse('h')
    end
    it "should consume 'hr'" do
      parser.s_hours.should parse('hr')
    end

    it "should consume 'H'" do
      parser.s_hours.should parse('H')
    end

    it "should consume 'hours'" do
      parser.s_hours.should parse('hours')
    end

    it "should consume 'hrs.'" do
      parser.s_hours.should parse('hrs.')
    end
  end

  context "ss" do
    it "should consume '00'" do
      parser.ss.should parse('00')
    end

    it "should consume '47'" do
      parser.ss.should parse('47')
    end

    it "should not consume '94'" do
      parser.ss.should_not parse('94')
    end
  end

  context 's_seconds' do
    it "should consume 's'" do
      parser.s_seconds.should parse('s')
    end

    it "should consume 'seconds'" do
      parser.s_seconds.should parse('seconds')
    end

    it "should consume 'sec'" do
      parser.s_seconds.should parse('sec')
    end

    it "should consume 'secs'" do
      parser.s_seconds.should parse('secs')
    end

    it "should consume 's.'" do
      parser.s_seconds.should parse('s.')
    end
  end

  context "seconds" do
    it "should consume '45'" do
      parser.seconds.should parse('45')
    end

    it "should consume '36.234'" do
      parser.seconds.should parse('36.234')
    end
    
    it "should consume '23:09'" do
      parser.seconds.should parse('23:09')
    end

    it "should consume '13;28'" do
      parser.seconds.should parse('13;28')
    end

    it "should consume '0.26875'" do
      parser.seconds.should parse('0.26875')
    end
  end

  context 'frames' do
    it "should consume ';29'" do
      parser.frames.should parse(';29')
    end

    it "should consume ':12'" do
      parser.frames.should parse(':12')
    end
  end

  context 'smpte' do
    it "should consume '01:02:03:04'" do
      parser.smpte.should parse('01:02:03:04')
    end

    it "should consume '01:08:59:29'" do
      parser.smpte.should parse('01:08:59:29')
    end

    it "should consume '00:56:57;00'" do
      parser.smpte.should parse('00:56:57;00')
    end
  end

  context "h_m" do
    it "should consume '1:23'" do
      parser.h_m.should parse('1:23')
    end

    it "should consume '04:32'" do
      parser.h_m.should parse('04:32')
    end
  end

  context "m_s" do
    it "should consume '03:53'" do
      parser.m_s.should parse('03:53')
    end

    it "should consume '6:33'" do
      parser.m_s.should parse('6:33')
    end

    it "should consume '12:22:23'" do
      parser.m_s.should parse('12:22:23')
    end

    it "should consume '43:01;12'" do
      parser.m_s.should parse('43:01;12')
    end

    it "should consume '00:01.111'" do
      parser.m_s.should parse('00:01.111')
    end

    it "should consume '01:2.693'" do
      parser.m_s.should parse('01:2.693')
    end
  end

  context "m_s_f" do
    it "should not consume '03:53'" do
      parser.m_s_f.should_not parse('03:53')
    end
  end

  context "hr_min" do
    it "should consume '4h'" do
      parser.hr_min.should parse('4h')
    end

    it "should consume '1hr 34min'" do
      parser.hr_min.should parse('1hr 34min')
    end

    it "should not consume '1m 34sec'" do
      parser.hr_min.should_not parse('1m 34sec')
    end
  end

  context "min_sec" do
    it "should consume '2m34s'" do
      parser.min_sec.should parse('2m34s')
    end

    it "should consume '22m 11s'" do
      parser.min_sec.should parse('22m 11s')
    end

    it "should consume '94m'" do
      parser.min_sec.should parse('94m')
    end
  end

  context "s" do
    it "should consume '60s'" do
      parser.s.should parse('60s')
    end
  end


  context "exact" do
    it "should parse '00:01'" do
      parser.exact.should parse('00:01')
      parsed = parser.exact.parse('00:01')
      parsed[:minutes].should == '00'
      parsed[:seconds].should == '01'
    end

    it "should parse '00:01:02.043'" do
      parser.exact.should parse('00:01:02.043')
      parsed = parser.exact.parse('00:01:02.042')

      parsed[:hours].should == '00'
      parsed[:minutes].should == '01'
      parsed[:seconds].should == '02.042'
    end

    it "should parse '0:51:36'" do
      parser.exact.should parse('0:51:36')
      parsed = parser.exact.parse('0:51:36')

      parsed[:hours].should == '0'
      parsed[:minutes].should == '51'
      parsed[:seconds].should == '36'
    end

    it "should parse '0.26875'" do
      parser.exact.should parse('0.26875')
      parsed = parser.exact.parse('0.26875')

      parsed[:seconds].should == '0.26875'
    end

    it "should parse '00:56:57;00'" do
      parser.exact.should parse('00:56:57;00')
      parsed = parser.exact.parse('00:56:57;00')

      parsed[:hours].should == '00'
      parsed[:minutes].should == '56'
      parsed[:seconds].should == '57'
      parsed.should include(:df)
      parsed[:frames].should == '00'
    end

    it "should parse '01:2.693'" do
      parser.exact.should parse('01:2.693')
      parsed = parser.exact.parse('01:2.693')

      parsed[:minutes].should == '01'
      parsed[:seconds].should == '2.693' 
    end

    it "should parse '20:00m'" do
      parser.exact.should parse('20:00m')
      parsed = parser.exact.parse('20:00m')

      parsed[:minutes].should == '20'
      parsed[:seconds].should == '00'
    end

    it "should parse '21:44.450'" do
      parser.exact.should parse('21:44.450')
      parsed = parser.exact.parse('21:44.450')

      parsed[:minutes].should == '21'
      parsed[:seconds].should == '44.450'
    end

    it "should parse '227min.'" do
      parser.exact.should parse('227min.')
      parsed = parser.exact.parse('227min.')

      parsed[:minutes].should == '227'
    end

    it "should parse '229:00'" do
      parser.exact.should parse('229:00')
      parsed = parser.exact.parse('229:00')
      parsed[:minutes].should == '229'
      parsed[:seconds].should == '00'
    end

    it "should parse '22m 11s'" do
      parser.exact.should parse('22m 11s')
      parsed = parser.exact.parse('22m 11s')
      parsed[:minutes].should == '22'
      parsed[:seconds].should == '11'
    end

    it "should parse '25:04:00'" do
      parser.exact.should parse('25:04:00')
      parsed = parser.exact.parse('25:04:00')

      parsed[:minutes].should == '25'
      parsed[:seconds].should == '04'
      parsed[:frames].should == '00'
    end

    it "should parse '29:28'" do
      parser.exact.should parse('29:28')
      parsed = parser.exact.parse('29:28')
      parsed[:minutes].should == '29'
      parsed[:seconds].should == '28'
    end

    it "should parse '5100.0'" do
      parser.exact.should parse('5100.0')
      parsed = parser.exact.parse('5100.0')

      parsed[:seconds].should == '5100.0'
    end

    it "should parse '120'" do
      parser.exact.should parse('120')
      parsed = parser.exact.parse('120')
      parsed[:minutes].should == '120'
    end

    it "should parse '58\''" do
      parser.exact.should parse("58'")
      parsed = parser.exact.parse("58'")

      parsed[:minutes].should == "58"
    end

    it "should parse 4h" do
      parser.exact.should parse('4h')
      parsed = parser.exact.parse('4h')

      parsed[:hours].should == '4'
    end

    it "should parse '01:09:26 s'" do
      parser.exact.should parse('01:09:26 s')
      parsed = parser.exact.parse('01:09:26 s')

      parsed[:hours].should == '01'
      parsed[:minutes].should == '09'
      parsed[:seconds].should == '26'
    end
  end

  context "approximate" do
    it "should consume '00:00:00?'" do
      parser.approximate.should parse('00:00:00?')
    end

    it "should consume '8ish'" do 
      parser.approximate.should parse('8ish')
    end
    
    it "should consume '<1hr'" do
      parser.approximate.should parse('<1hr')

      parsed = parser.approximate.parse('<1hr')
      parsed.should include(:approximate)
      parsed[:approximate].should include(:lt)
    end

    it "should consume 'ca. 77m'" do
      parser.approximate.should parse('ca. 77m')
    end

    it "should consume 'approx. 32min'" do
      parser.approximate.should parse('approx. 32min')
    end
  end

  context "timecode" do
    it "should parse '01:09:26 s'" do
      parser.timecode.should parse('01:09:26 s')
      parsed = parser.timecode.parse('01:09:26 s')

      parsed[:hours].should == '01'
      parsed[:minutes].should == '09'
      parsed[:seconds].should == '26'
    end

    it "should parse '22:11?'" do
      parser.timecode.should parse('22:11?')
      parsed = parser.timecode.parse('22:11?')

      parsed[:minutes].should == '22'
      parsed[:seconds].should == '11'
      parsed.should include(:approximate)
    end
  end

  context "duration" do
    it "should consume 'TRT 25:57'" do
      parser.duration.should parse('TRT 25:57')
    end

    it "should consume ':00:26:30'" do
      parser.duration.should parse(':00:26:30')
    end
  end
end
