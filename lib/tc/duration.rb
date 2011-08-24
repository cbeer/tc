require 'parslet'

class Tc::Duration < Parslet::Parser
  def stri(str)
    key_chars = str.split(//)
    key_chars.
      collect! { |char| match["#{char.upcase}#{char.downcase}"] }.
      reduce(:>>)
  end


  # base units
  rule(:integer) { match('[0-9]') }
  rule(:space) { match('\s').repeat(1) }
  rule(:space?) { space.maybe }

  rule(:arbitrary_length_integer) { integer.repeat(1) }
  rule(:one_or_two_digit_integer) { integer.repeat(1,2) }
  rule(:zero_zero_to_fifty_nine) { (match('[0-5]') >> match('[0-9]') | match('[0-9]')) }
  rule(:zero_zero_to_twenty_nine) { (match('[0-2]') >> match('[0-9]') | match('[0-9]')) }

  #separators
  rule(:separator) { match(':') }
  rule(:ndf_separator) { match(':').as(:ndf) }
  rule(:df_separator) { match(';').as(:df) }

  # unit strings
  rule(:s_seconds) { ((space? >> stri('s') >> (stri('ec') >> stri('s').maybe).maybe >> (str('.') | stri('ond')).maybe >> stri('s').maybe) | str('"'))}
  rule(:s_minutes) { ((space? >> stri('m') >> stri('in').maybe >> (str('.') | str('s') | (stri('ute') >> stri('s')).maybe).maybe) | str("'"))}
  rule(:s_hours) { (space? >> stri('h') >> ((stri('r') >> stri('s').maybe >> str('.').maybe) | (stri('our').maybe >> stri('s').maybe )).maybe) }

  # unit values
  
  # idealized
  rule(:ff) { zero_zero_to_twenty_nine >> integer.absnt? }
  rule(:ss) { zero_zero_to_fifty_nine }
  rule(:mm) { zero_zero_to_fifty_nine >> integer.absnt? }
  rule(:hh) { arbitrary_length_integer }

  # seconds
  rule(:sec) { arbitrary_length_integer }
  rule(:fraction) { str('.') >> arbitrary_length_integer }
  rule(:frame) { zero_zero_to_fifty_nine >> integer.absnt? }

  # minutes
  rule(:min) { arbitrary_length_integer }

  # hours
  rule(:zero_to_three) { match('[0-3]')  >> integer.absnt?}
  rule(:zero_zero_to_zero_three) { str('0') >> match('[0-3]')  >> integer.absnt?}
  rule(:small_h) { (zero_to_three | zero_zero_to_zero_three) }
  rule(:small_m) { ((match('[0-3]') >> integer >> integer) | (integer >> integer) ).as(:minutes) >> integer.absnt?}

  # unit matchers
  rule(:frames) { (ndf_separator | df_separator) >> (ff | frame).as(:frames) }
  rule(:seconds_f) { ((sec >> fraction).as(:seconds) | ( sec.as(:seconds) >> frames )) }
  rule(:seconds) { (seconds_f | sec.as(:seconds) ) }
  rule(:minutes) { (mm | min).as(:minutes) >> (integer | str('.')).absnt? }
  rule(:hours) { hh.as(:hours) }

  rule(:s) { seconds  >> s_seconds.maybe }
  rule(:h) { hours >> s_hours.maybe }
  rule(:m) { minutes >> s_minutes.maybe }

  rule(:m_mins) { minutes >> s_minutes }
  rule(:s_secs) { seconds >> s_seconds }


  # timecode matchers
  rule(:smpte) { hh.as(:hours) >> separator >> mm.as(:minutes) >> separator >> ss.as(:seconds) >> frames } 
  rule(:h_m) { hours >> separator >> minutes >> s_minutes.maybe }
  rule(:h_m_s) { hours >> separator >> minutes >> separator >> seconds >> s_seconds.maybe }
  rule(:small_h_m_s) { small_h.as(:hours) >> separator >> minutes >> separator >> seconds >> s_seconds.maybe } 
  rule(:m_s) { minutes >> separator >> seconds >> (s_minutes | s_seconds).maybe }
  rule(:m_s_f) { minutes >> separator >> seconds_f >> s_seconds.maybe }

  rule(:hr_min) { hours >> s_hours >> space? >> (minutes >> s_minutes.maybe).maybe }
  rule(:hr_min_sec) { hours >> s_hours >> space? >> minutes >> s_minutes.maybe >> space? >> seconds >> s_seconds.maybe }
  rule(:min_sec) {  minutes >> s_minutes >> space? >> (seconds >> s_seconds.maybe).maybe }

  rule(:unambiguous) { smpte | small_h_m_s | hr_min | hr_min_sec | min_sec }
  rule(:ambiguous) { m_s_f | h_m_s | m_s | h_m | m_mins | s_secs | small_m | s | m }
  rule(:exact) { unambiguous | ambiguous }

  # approximate indicators
  rule(:q) { str('?') }
  rule(:ca) { str('c') >> str('a').maybe >> (str('.') | str(',')).maybe }
  rule(:gt) { str('>').as(:gt) }
  rule(:lt) { str('<').as(:lt) }
  rule(:ish) { str('ish') }
  rule(:s_approx) { str('approx') >> str('.').maybe }

  # full matchers
  rule(:approx) { space? >> (s_approx | q | ca | gt |lt | ish).as(:approximate) >> space?}
  rule(:approximate_head) { approx >> exact }
  rule(:approximate_tail) { exact >> approx }
  rule(:approximate) { approximate_head | approximate_tail }
  rule(:timecode) { approximate | exact }

  # header tokens
  rule(:trt) { str('TRT').as(:trt) >> space? >> timecode }
  rule(:colon_prefix) { str(':') >> timecode }

  rule(:duration) { trt | colon_prefix | timecode } 

  root :duration
end
