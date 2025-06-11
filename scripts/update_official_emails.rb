# frozen_string_literal: true

require 'logger'
require 'fileutils'

# Set up the relative logs directory and log file path
script_dir = __dir__
logs_dir = File.expand_path('../log', script_dir)
FileUtils.mkdir_p(logs_dir)
log_file_path = File.join(logs_dir, 'update_official_emails.log')

logger = Logger.new(log_file_path)

emails = [
  'foster.sentala@oxygenalliance.org',
  'rodger.kumwanje@oxygenalliance.org',
  'victor.mzembe@oxygenalliance.org',
  'janet.douglas@oxygenalliance.org',
  'lloyd.kayembe@oxygenalliance.org',
  'timothy.banda@ghii.org',
  'aubrey.chinkunda@ghii.org',
  'benjamin.munyenyembe@ghii.org',
  'bryan.malunje@ghii.org',
  'carolyn.kazado@ghii.org',
  'cecilia.kapalamula@ghii.org',
  'cletia.nsambo@ghii.org',
  'deliwe.nkhoma@ghii.org',
  'dereck.katuli@ghii.org',
  'doreen.thotho@ghii.org',
  'frank.gondwe@ghii.org',
  'jones.blackwell@ghii.org',
  'kelvin.msiska@ghii.org',
  'lekodi.magombo@ghii.org',
  'luke.kamvazina@ghii.org',
  'martha.madziatera@ghii.org',
  'micheal.harawa@ghii.org',
  'moses.gwaza@ghii.org',
  'mtheto.sinjani@ghii.org',
  'mwabi.lungu@ghii.org',
  'neo.kazembe@ghii.org',
  'oveka.mwanza@ghii.org',
  'peter.namagonya@ghii.org',
  'pistone.sanjama@ghii.org',
  'rashid.deula@ghii.org',
  'richard.kachipapa@ghii.org',
  'rosert.malikebu@ghii.org',
  'sophie.mvula@ghii.org',
  'steven.kholowa@ghii.org',
  'tamika.mulenga@ghii.org',
  'teleza.kanthonga@ghii.org',
  'thokozani.chirombo@ghii.org',
  'timmtonga@ghii.org',
  'wiza.munthali@ghii.org',
  'wonderful.lijoni@ghii.org',
  'yamikani.sita@ghii.org',
  'yawapo.chibaka@ghii.org',
  'chimwemwe.tiyesi@ghii.org',
  'titani.manda@ghii.org'
]

success_count = 0
failure_count = 0

emails.each do |email|
  local_part = email.split('@').first
  first_name, last_name = local_part.split('.')

  if first_name.nil? || last_name.nil?
    logger.error("Invalid email format for: #{email}")
    failure_count += 1
    next
  end

  person = Person.where('LOWER(first_name) = ? AND LOWER(last_name) = ?', first_name.downcase, last_name.downcase).first

  if person
    if person.official_email.nil?
      person.update(official_email: email)
      logger.info("Successfully updated email for #{person.first_name} #{person.last_name}")
      success_count += 1
    else
      logger.info("Skipped updating email for #{person.first_name} #{person.last_name} as official_email is already set")
    end
  else
    logger.error("Failed to find person with name #{first_name} #{last_name}")
    failure_count += 1
  end
end

logger.info("Total successful updates: #{success_count}")
logger.info("Total failures: #{failure_count}")
