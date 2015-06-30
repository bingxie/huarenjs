worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 60 # seconds, keep this lower than 30 if deployed to heroku
preload_app true

pid               "#{ENV['APP_PATH']}/tmp/pids/unicorn.pid"
listen            "#{ENV['APP_PATH']}/tmp/sockets/unicorn.sock"
working_directory "#{ENV['APP_PATH']}/current"

stderr_path "#{ENV['APP_PATH']}/shared/log/jishi-web.log"
stdout_path "#{ENV['APP_PATH']}/shared/log/jishi-web.log"

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{ENV['APP_PATH']}/current/Gemfile"
end

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # Graceful restart unicorn
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && old_pid != server.pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end
