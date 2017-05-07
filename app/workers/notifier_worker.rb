class NotifierWorker
  include Sidekiq::Worker

  # sidekiq_options retry: false

  def perform
    # Do something
    User.all.each do |user|
      @user_words = UserWord.all.where(learned: false, user: user)
      NotificationMailer.send_words(user, @user_words).deliver unless @user_words.empty?
    end
  end

  # job = Sidekiq::Cron::Job.create(name: 'Notifier worker - every 5 minutes', cron: '*/5 * * * *', class: 'NotifierWorker')
end
