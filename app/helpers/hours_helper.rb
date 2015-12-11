module HoursHelper

  def formated_time(time)
    hours = time.to_i
    minutes = format '%02d', ((time - time.to_i)*1.minute).round
    hours.to_s + ':' + minutes.to_s
  end
end
