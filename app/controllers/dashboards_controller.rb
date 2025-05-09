# frozen_string_literal: true

class DashboardsController < ApplicationController # rubocop:disable Style/Documentation
  def dashboards # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @target_dashboard = 'headcount_growth'
    @metadata = case @target_dashboard # rubocop:disable Style/HashLikeCase
                when 'headcount_growth'
                  {
                    'title': 'Head Count and Growth',
                    'subtitle_1': "#{(Date.today.month - 1) / 3 + 1} Quarter - #{Date.today.year}", # rubocop:disable Naming/VariableNumber
                    'subtitle_2': 'Informatics Team', # rubocop:disable Naming/VariableNumber
                    'headcount': Employee.where(still_employed: true).count,
                    'new_hires': Employee.where(still_employed: true,
                                                employment_date: Date.current.beginning_of_quarter..Date.current.end_of_quarter).count, # rubocop:disable Layout/LineLength
                    'new_departures': Employee.where(still_employed: false,
                                                     departure_date: Date.current.beginning_of_quarter..Date.current.end_of_quarter).count, # rubocop:disable Layout/LineLength
                    'gender_female': Employee.joins(:person).where(people: { gender: 'Female' }).count || 0,
                    'gender_male': Employee.joins(:person).where(people: { gender: 'Male' }).count || 0,
                    'gender_other': Employee.joins(:person).where.not(people: { gender: %w[Female Male] }).count || 0,
                    

                  }
                when 'demographic_age_gender'
                  {
                    'title': 'Gender And Age Groups',
                    'subtitle_1': 'lorem', # rubocop:disable Naming/VariableNumber
                    'subtitle_2': 'lorem' # rubocop:disable Naming/VariableNumber
                  }
                when 'demographic_tenure'
                  {
                    'title': 'Tenure',
                    'subtitle_1': 'lorem', # rubocop:disable Naming/VariableNumber
                    'subtitle_2': 'lorem' # rubocop:disable Naming/VariableNumber
                  }
                end
  end
end
