# frozen_string_literal: true

# app/services/rewards_read_service.rb
require 'active_record'
URL = ENV['RECOGNITION_URL'] || 'http://xxx:xxxx/'

class RemoteBase < ActiveRecord::Base # rubocop:disable Style/Documentation
  self.abstract_class = true
  establish_connection(
    adapter: 'postgresql',
    host: ENV['RECOGNITION_DB_HOST'] || 'localhost',
    port: ENV['RECOGNITION_DB_PORT'] || 5432,
    username: ENV['RECOGNITION_DB_USER'] || 'user',
    password: ENV['RECOGNITION_DB_PASSWORD'] || 'password',
    database: ENV['RECOGNITION_DB_NAME'] || 'rr_db'
  )
end

class RemoteCompetition < RemoteBase # rubocop:disable Style/Documentation
  self.table_name = 'competitions'
end

class RemotePerson < RemoteBase # rubocop:disable Style/Documentation
  self.table_name = 'people'
end

class RemotePointsLog < RemoteBase # rubocop:disable Style/Documentation
  self.table_name = 'points_logs' # use actual table name in DB
end

class RemoteVote < RemoteBase # rubocop:disable Style/Documentation
  self.table_name = 'votes' # use actual table name in DB
end

# Service to read recognition and reward data
class RecognitionRewardService
  def self.call
    new.call
  end

  def call
    recognition_reward_data
  end
end

def recognition_reward_data # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  contest_count = RemoteCompetition
                  .where('competition_type = ? AND end_date >= ?', 'Contest', Date.today)
                  .count

  election_count = RemoteCompetition
                   .where('competition_type = ? AND end_date >= ?', 'Election', Date.today)
                   .count

  active_contest_ids = RemoteCompetition
                       .where(competition_type: 'Contest')
                       .where('end_date >= ?', Date.today)
                       .pluck(:competition_id)

  active_election_ids = RemoteCompetition
                        .where(competition_type: 'Election')
                        .where('end_date >= ?', Date.today)
                        .pluck(:competition_id)

  top_contestees = []
  top_electionees = []

  active_contest_ids.each do |competition_id|
    receivers = RemotePointsLog
                .joins('JOIN people ON people.person_id = points_logs.receiver')
                .select("CONCAT(people.first_name, ' ', people.last_name) AS receiver_name,
                          SUM(points_awarded) AS vote_count,
                          competition_id")
                .where(competition_id:)
                .group('people.first_name, people.last_name, competition_id')
                .order('vote_count DESC')
                .limit(3)
                .to_a
    top_contestees.concat(receivers)
  end

  active_election_ids.each do |competition_id|
    receivers = RemoteVote
                .joins('JOIN people ON people.person_id = votes.receiver')
                .select("CONCAT(people.first_name, ' ', people.last_name) AS receiver_name,
                          COUNT(votes.vote_id) AS vote_count,
                          competition_id")
                .where(competition_id:)
                .group('people.first_name, people.last_name, competition_id')
                .order('vote_count DESC')
                .limit(3)
                .to_a
    top_electionees.concat(receivers)
  end

  # Map to readable hashes
  active_contest_data = top_contestees.map do |r|
    {
      receiver_name: r.receiver_name,
      vote_count: r.vote_count.to_i,
      competition_id: r.competition_id,
      competition_name: RemoteCompetition.find_by(competition_id: r.competition_id)&.name
    }
  end

  active_election_data = top_electionees.map do |r|
    {
      receiver_name: r.receiver_name,
      vote_count: r.vote_count.to_i,
      competition_id: r.competition_id,
      competition_name: RemoteCompetition.find_by(competition_id: r.competition_id)&.name
    }
  end

  {
    contest_count:,
    election_count:,
    active_contest_data:,
    active_election_data:,
    RECOGNITION_URL: URL
  }
end
