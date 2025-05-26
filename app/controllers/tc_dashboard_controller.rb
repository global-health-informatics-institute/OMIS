class TcDashboardController < ApplicationController
# frozen_string_literal: true

  def index
    @common_data, @gender_age, @tenure, @project = prepare_dashboard_data
  end

  def gender_age
    @common_data, @gender_age = prepare_dashboard_data
  end

  def tenure
    @common_data, @tenure = prepare_dashboard_data
  end

  def project
    @common_data, @project = prepare_dashboard_data
  end

  private

  def prepare_dashboard_data # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    @common_data = {
      subtitle_1: "#{(Date.today.month - 1) / 3 + 1} Quarter - #{Date.today.year}", # rubocop:disable Naming/VariableNumber
      subtitle_2: 'Informatics Team' # rubocop:disable Naming/VariableNumber
    }

    @gender_age = {
      title: 'WORKFORCE',
      card_title_1: 'Age Distribution', # rubocop:disable Naming/VariableNumber
      card_title_2: 'Gender Distribution', # rubocop:disable Naming/VariableNumber

      past_four_months:,
      past_four_months_trend: past_four_months_headcount,

      gender_female: Employee.joins(:person).where(people: { gender: 'Female' }).count || 0,
      gender_male: Employee.joins(:person).where(people: { gender: 'Male' }).count || 0,
      gender_other: Employee.joins(:person).where.not(people: { gender: %w[Female Male] }).count || 0,

      age_18_25: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 25.years.ago..18.years.ago }).count || 0,
      age_26_35: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 35.years.ago..26.years.ago }).count || 0,
      age_36_45: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 45.years.ago..36.years.ago }).count || 0,
      age_46_55: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 55.years.ago..46.years.ago }).count || 0,
      age_56_65: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 65.years.ago..56.years.ago }).count || 0,
      above_65: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                        .where(still_employed: true)
                        .where('people.birth_date <= ?', 65.years.ago).count || 0,

      headcount: Employee.where(still_employed: true).count,
      new_hires: Employee.where(still_employed: true,
                                employment_date: Date.current.beginning_of_quarter..Date.current.end_of_quarter).count # rubocop:disable Layout/LineLength
    }

    @tenure = {
      title: 'GROWTH',

      card_title_1: 'Retention Trend', # rubocop:disable Naming/VariableNumber
      past_four_year_quarters:,
      past_four_year_quarter_trend: past_four_year_quarters_trend,

      card_title_2: 'Headcount for the Last 4 Months', # rubocop:disable Naming/VariableNumber
      past_four_months:,
      past_four_months_trend: past_four_months_headcount,

      card_title_3: 'Workforce Distribution', # rubocop:disable Naming/VariableNumber
      workforce_types: workforce_types.keys,
      workforce_type_distribution: workforce_types.values
    }

    @project = {
      title: 'GHII PROJECTS',

      projects: Project.where(is_active: true)
                       .where('LOWER(project_name) NOT LIKE ALL (ARRAY[?, ?, ?])', '%leave%', '%holiday%', '%crosscutting%') # rubocop:disable Layout/LineLength
                       .map do |project|
        {
          project_name: project.short_name

        }
      end # rubocop:disable Layout/BlockAlignment
    }

    @tenure[:past_four_year_quarter_trend] = @tenure[:past_four_year_quarter_trend]
                                             .compact
                                             .reject { |v| v.respond_to?(:nan?) && v.nan? }
                                             .map { |v| (v * 100).round(2) if v.respond_to?(:*) }

    [@common_data, @gender_age, @tenure, @project]
  end

  def past_four_months
    (0..3).map { |i| (Date.today - i.months).strftime('%b') }.reverse
  end

  def past_four_months_headcount
    (0..3).map do |i|
      month_end = (Date.today - i.months).end_of_month
      Employee.where(still_employed: true)
              .where('employment_date <= ?', month_end)
              .where('departure_date IS NULL OR departure_date > ?', month_end)
              .count
    end.reverse
  end

  def workforce_types # rubocop:disable Metrics/MethodLength
    counts = {
      'full_time' => 0,
      'part_time' => 0,
      'intern' => 0,
      'volunteer' => 0
    }

    Employee.where(still_employed: true).includes(:employee_designations).find_each do |employee|
      type = employee.employment_type.to_s.downcase

      case type
      when /intern/
        counts['intern'] += 1
      when /volunteer/
        counts['volunteer'] += 1
      when /part/
        counts['part_time'] += 1
      else
        counts['full_time'] += 1
      end
    end

    counts
  end

  def past_four_year_quarters
    ReportStatistic.where(statistic_description: 'Retention Rate')
                   .where.not(statistic_value: [nil, Float::NAN])
                   .limit(20)
                   .pluck(:period_label)
  end

  def past_four_year_quarters_trend
    ReportStatistic.where(statistic_description: 'Retention Rate')
                   .limit(20)
                   .pluck(:statistic_value)
                   .map { |v| v.nan? ? nil : v }
  rescue StandardError => e
    Rails.logger.error("Error fetching retention data: #{e.message}")
    []
  end
end
