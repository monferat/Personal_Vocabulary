#rake pv_notifier:send_notification
desc 'Send notification about words to user'
namespace :pv_notifier do
  task :send_notification => :environment do
    puts 'Adding job for sending notification about words to user...'
    # Sidekiq::Cron::Job.create(name: 'Notifier worker - every 5 minutes', cron: '*/5 * * * *', class: 'NotifierWorker')
    Sidekiq::Cron::Job.create(name: 'Notifier worker - every 1 month', cron: '0 0 1 * *', class: 'NotifierWorker')
    puts 'done.'
  end
end
