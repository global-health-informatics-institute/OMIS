# frozen_string_literal: true
require 'yaml'
class TcDashboardController < ApplicationController # rubocop:disable Metrics/ClassLength,Style/Documentation
  def index
    @common_data, @gender_age, @tenure, @project, @project_metadata = prepare_dashboard_data
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
      subtitle_2: 'Informatics Team', # rubocop:disable Naming/VariableNumber
      organization_shortname: GlobalProperty.find_by(property: 'dashboard.metadata')&.property_value&.split(',')&.first || 'Default Shortname', # rubocop:disable Layout/LineLength
      organization_logo: GlobalProperty.find_by(property: 'dashboard.metadata')&.property_value&.split(',')&.second || 'Default Shortname' # rubocop:disable Layout/LineLength
    }

    @gender_age = {
      title: 'WORKFORCE',
      card_title_1: 'Age Distribution', # rubocop:disable Naming/VariableNumber
      card_title_2: 'Gender Distribution', # rubocop:disable Naming/VariableNumber

      past_four_months:,
      past_four_months_trend: past_four_months_headcount,

      gender_female: Employee.where(still_employed: true).joins(:person).where(people: { gender: 'Female' }).count || 0,
      gender_male: Employee.where(still_employed: true).joins(:person).where(people: { gender: 'Male' }).count || 0,
      gender_other: Employee.where(still_employed: true).joins(:person).where.not(people: { gender: %w[Female Male] }).count || 0,

      age_18_24: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 24.years.ago..18.years.ago }).count || 0,
      age_25_29: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 35.years.ago..26.years.ago }).count || 0,
      age_30_44: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 45.years.ago..36.years.ago }).count || 0,
      age_46_60: Employee.joins(:person) # rubocop:disable Naming/VariableNumber
                          .where(still_employed: true)
                          .where(people: { birth_date: 55.years.ago..46.years.ago }).count || 0,
      age_60_plus: Employee.joins(:person)
                          .where(still_employed: true)
                          .where('people.birth_date <= ?', 60.years.ago).count || 0,
    

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
      headcount_by_quarter: headcount_by_quarter(past_four_year_quarters),

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

    @project_metadata = YAML.safe_load(
      File.read(Rails.root.join('config', 'dashboard_metadata.yml')),
      permitted_classes: [Date], # Optional: Only if you want Dates parsed
      aliases: true
    )

    @tenure[:past_four_year_quarter_trend] = @tenure[:past_four_year_quarter_trend]
                                             .compact
                                             .reject { |v| v.respond_to?(:nan?) && v.nan? }
                                             .map { |v| (v * 100).round(2) if v.respond_to?(:*) }

    [@common_data, @gender_age, @tenure, @project, @project_metadata]
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

  def headcount_by_quarter(quarters = past_four_year_quarters)
    quarters.each_with_object({}) do |quarter, result|
      year, q = quarter.split('-Q').map(&:to_i)
      start_month = (q - 1) * 3 + 1
      start_date = Date.new(year, start_month, 1)
      end_date = start_date.end_of_quarter

      count = Employee.where('employment_date <= ?', end_date)
                      .where('departure_date IS NULL OR departure_date >= ?', start_date)
                      .count

      result[quarter] = count
    end
  end
end
