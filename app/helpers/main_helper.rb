module MainHelper
  def categorize_employees(records)
    gender_summary = Hash.new(0)
    age_summary = Hash.new(0)
    (records || []).each do |record|
      gender_summary[record.gender] +=1
      age = Date.today.year - record.birth_date.year
      if (age >=18) && (age <=24)
        age_summary["18-24"] +=1
      elsif (age >=25) && (age <30)
        age_summary["25-29"] +=1
      elsif (age >=30) && (age <45)
        age_summary["30-44"] +=1
      elsif (age >=45) && (age <=60)
        age_summary["45-60"] +=1
      else
        age_summary["60+"] +=1
      end
    end
    return gender_summary, age_summary
  end
end
