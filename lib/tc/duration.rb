require 'parslet'

class Tc::Duration < Parslet::Parser
  # base unites
  rule(:integer) { match('[0-9]') }
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }
  rule(:zero_zero_to_fifty_nine) { match('[0-5]') >> match('[0-9]') }

  #separators
  rule(:separator) { match(':') }
  rule(:ndf_separator) { match(':').as(:ndf) }
  rule(:df_separator) { match(';').as(:df) }

  # unit strings
  rule(:s_seconds) { (space? >> match('[Ss]') >> (str('ec') >> str('s').maybe).maybe >> (str('.') | str('ond')).maybe >> str('s').maybe) | str('"')}
  rule(:s_minutes) { (space? >> match['Mm'] >> (str('in') | str('IN')).maybe >> (str('.') | (str('ute') >> str('s')).maybe).maybe) | str("'")}
  rule(:s_hours) { space? >> match['Hh'] >> ((str('r') >> str('s').maybe >> str('.').maybe) | (str('our').maybe >> str('s').maybe )).maybe }

  # unit values

  # seconds
  rule(:ss) { ((match('[0-5]') >> match('[0-9]')) | match('[0-9]') ) >> integer.absnt? }
  rule(:sec) { ss | integer.repeat(1) }
  rule(:fraction) { str('.') >> integer.repeat(1)}
  rule(:ff) { match('[0-2]') >> match('[0-9]') >> integer.absnt? }
  rule(:frame) { match('[0-5]') >> match('[0-9]') >> integer.absnt? }

  # minutes
  rule(:mm) { ((match('[0-5]') >> match('[0-9]')) | match('[0-9]')) >> integer.absnt? }
  rule(:min) { integer.repeat(1) }

  #hours
  rule(:hh) { integer.repeat(1) }
  rule(:small_h) { str('0').maybe >> match('[0-2]') >> integer.absnt? }

  # unit matchers
  rule(:frames) { (ndf_separator | df_separator) >> (ff | frame).as(:frames) }
  rule(:seconds_f) { ((sec >> fraction).as(:seconds) | ( sec.as(:seconds) >> frames )) }
  rule(:seconds) { (seconds_f | sec.as(:seconds) ) }
  rule(:minutes) { (mm | min).as(:minutes) >> (integer | str('.')).absnt? }
  rule(:hours) { hh.as(:hours) }

  rule(:s) { seconds  >> s_seconds.maybe }
  rule(:h) { hours >> s_hours.maybe }
  rule(:m) { minutes >> s_minutes.maybe }

  # timecode matchers
  rule(:smpte) { integer.repeat(1).as(:hours) >> separator >> zero_zero_to_fifty_nine.as(:minutes) >> separator >> zero_zero_to_fifty_nine.as(:seconds) >> frames } 
  rule(:h_m) { hours >> separator >> minutes >> s_minutes.maybe }
  rule(:h_m_s) { hours >> separator >> minutes >> separator >> seconds >> s_seconds.maybe }
  rule(:small_h_m_s) { small_h.as(:hours) >> separator >> minutes >> separator >> seconds >> s_seconds.maybe } 
  rule(:m_s) { minutes >> separator >> seconds >> (s_minutes | s_seconds).maybe }
  rule(:m_s_f) { minutes >> separator >> seconds_f >> s_seconds.maybe }

  rule(:hr_min) { hours >> s_hours >> space? >> (minutes >> s_minutes.maybe).maybe }
  rule(:hr_min_sec) { hours >> s_hours >> space? >> minutes >> s_minutes.maybe >> space? >> seconds >> s_seconds.maybe }
  rule(:min_sec) {  minutes >> s_minutes >> space? >> (seconds >> s_seconds.maybe).maybe }

  rule(:unambiguous) { smpte | small_h_m_s | hr_min | hr_min_sec | min_sec }
  rule(:ambiguous) { m_s_f | h_m_s | m_s | h_m | m | s }
  rule(:exact) { unambiguous | ambiguous }

  # approximate indicators
  rule(:q) { str('?') }
  rule(:ca) { str('c') >> str('a').maybe >> (str('.') | str(',')).maybe }
  rule(:gt) { str('>') }
  rule(:lt) { str('<') }
  rule(:ish) { str('ish') }

  # full matchers
  rule(:approx) { space? >> (q | ca | gt |lt | ish).as(:approximate) >> space?}
  rule(:approximate_head) { approx >> exact }
  rule(:approximate_tail) { exact >> approx }
  rule(:approximate) { approximate_head | approximate_tail }
  rule(:timecode) { approximate | exact }

  # header tokens
  rule(:trt) { str('TRT').as(:trt) >> space? }
  rule(:colon_prefix) { str(':') }

  rule(:duration) { (trt | colon_prefix).maybe >> timecode } 

  root :duration
end
