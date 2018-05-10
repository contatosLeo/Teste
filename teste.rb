def change_date(date, op, value)
  dates = date.split(' ')

  if (op != '-' && op != '+')
    raise ArgumentError.new("Invalid operator")
  end

  value = value.to_s
  value.gsub! '-', ''
  value.gsub! '+', ''

  value = value.to_i
  
  value_date = dates[0].split('/')
  value_time = dates[1].split(':')
  
  value_days = value_date[0].to_i
  value_months = value_date[1].to_i
  value_years = value_date[2].to_i
  
  value_hours = value_time[0].to_i
  value_minutes = value_time[1].to_i
  
  hours = value / 60
  days = hours / 24
  months = days / 30
  years = months / 12

  minutes = value - (hours * 60)
  hours -= (days * 24)
  days -= (months * 30)
  months -= (years * 12)  
  
  if(op == '+')
    value_days += days
    value_months += months
    value_years += years
    value_minutes += minutes
    value_hours += hours
    
    params = valid_date_positive(value_days, value_months, value_years, value_hours, value_minutes)
  else
    value_days -= days
    value_months -= months
    value_years -= years
    value_minutes -= minutes
    value_hours -= hours
    
    params = valid_date_negative(value_days, value_months, value_years, value_hours, value_minutes)
    
  end
      
  print_value(params)
  
end

def valid_date_positive(days, months, years, hours, minutes)
    if(minutes > 59)
        hour = minutes / 60
        hours += hour
        minutes -= (hour * 60) 
    end
    
    if(hours > 23)
        day = hours / 24
        days += day
        hours -= (day * 24)
    end
    
    if(days > 31)
        month = days / 31
        months += month
        days -= (month * 31)
    end

    if(months > 12)
        year = months / 12
        years += year
        months -= (year * 12)
    end

    if(months == 2 && days > 28)
        months += 1
        days -= 28
    end

    if([4, 6, 9, 11].include? months && days > 30)
        months += 1
        days -= 30
    end

    return [
        days: days,
        months: months,
        hours: hours,
        minutes: minutes,
        years: years
    ]
end

def valid_date_negative(days, months, years, hours, minutes)
    if(minutes < 0)
        hours -= 1
        minutes += 60 
    end

    if(hours < 0)
        days -= 1
        hours += 24
    end

    if(days < 0)
        months -= 1

        if(months == 2)
            days += 28
        elsif([4, 6, 9, 11].include? months)
            days += 30
        else
            days += 31
        end
    end

    if(months < 0)
        years -= 1
        months += 12
    end

    if(months == 2 && days > 28)
        months += 1
        days -= 28
    end

    if([4, 6, 9, 11].include? months && days > 30)
        months += 1
        days -= 30
    end

    return [
        days: days,
        months: months,
        hours: hours,
        minutes: minutes,
        years: years
    ]
end

def print_value(params)
    params = params[0]
    days = (params[:days] < 10) ? "0#{params[:days]}" : params[:days]
    months = (params[:months] < 10) ? "0#{params[:months]}" : params[:months]
    hours = (params[:hours] < 10) ? "0#{params[:hours]}" : params[:hours]
    minutes = (params[:minutes] < 10) ? "0#{params[:minutes]}" : params[:minutes]

    puts "#{days}/#{months}/#{params[:years]} #{hours}:#{minutes}" 
end

if(ARGV.length == 4)
    puts '-- SEND PARAMS'
    params = ARGV
    val_date = "#{params[0]} #{params[1]}"
    operator = params[2]
    value = params[3].to_i
else
    val_date = "01/03/2010 23:00"
    operator = '+'
    value = 4000
end

change_date(val_date, operator, value)
