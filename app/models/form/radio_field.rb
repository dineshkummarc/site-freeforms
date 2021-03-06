class Form::RadioField < Form::Field

  def variants
    @variants ||= []
  end

  def variants=(v)
    v = v.split /\r?\n/ if v.respond_to? :split

    @variants = v
  end

  def type
    :radio
  end

  def render_value( value )
    value
  end

  def process_value( v )
    i = v.to_i
    if i >=0 && i < variants.size
      variants[i]
    else
      'unknown'
    end
  end

  def render_input( form_id, field_num )
    s = "<p id=\"mf_#{form_id}_#{field_num}\" class=\"mf_radio\"><label for=\"fields[#{field_num}]\">#{escaped_title}</label>"

    variants.each_with_index do |v,i|
      s << "<input type=\"radio\" name=\"fields[#{field_num}]\" value=\"#{i}\""
      s << " checked=\"true\"" if v == default
      s << ">#{e v}</input>"
    end

    s << "<span id=\"mfe_#{form_id}_#{field_num}\"></span></p>"
    s.html_safe
  end

  def error_for(value)
    v = super

    return v if v
    return I18n.t('fields.errors.select.invalid') unless value.blank? || variants.include?( value )

    nil
  end

  def support_stats?
    true
  end

end
