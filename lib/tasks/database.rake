require 'active_record'
require 'pg'

Dir.glob('./app/models/**/*.rb').each { require(it) }

namespace :db do
  DB_HOST = '8.8.8.8' # '13.13.13.13'
  DB_NAME = 'default_database_staging'
  DB_BACKUP_DIR = 'backups'

  desc 'dump the database'
  task :dump, [:db_name] => :check_connection do |current_task, kwargs|
    target_database = kwargs&.db_name || DB_NAME
    puts "dumping #{target_database}"

    mkdir_p DB_BACKUP_DIR

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')

    file_full_path = "#{DB_BACKUP_DIR}/#{target_database}_#{timestamp}.sql.gz"

    sh "pg_dump #{target_database} | gzip > #{file_full_path}"
    puts "Backup saved to #{file_full_path}"
  end

  desc 'check connection'
  task :check_connection do
    puts 'checking connection...'
    begin
      sh "ping -c 4 #{DB_HOST}"
    rescue => error
      message = "Connection Failed -> #{error.message}"
      puts "\e[31m#{message}\e[0m"
      exit
    end
  end

  task :setup_connection do
    # ActiveRecord::Base.establish_connection(
    #   adapter: 'postgresql',
    #   # host: 'localhost',
    #   database: 'listinha_development',
    #   username: 'xita',
    #   # password: 'postgresql
    # )
    # schemas

    # user = 'seu_usuario'
    # password = 'sua_Senha'
    # host = 'localhost'
    # db = 'listinha_Development'
    # port = '5432'
    # db_url = "postgresql://#{user}:#{password}@#{host}:#{port}/#{db}"
    
    db_url = "postgresql:///listinha_development?host=/var/run/postgresql"

    ActiveRecord::Base.establish_connection(db_url)

    ActiveRecord::Base.connection
  end

  task seed: :setup_connection  do
    load 'db/seed.rb'

    # puts User.find_by(email: 'puts_dev@puts_dev.com').as_json
    puts "Seed ran correctly"
  end
end
