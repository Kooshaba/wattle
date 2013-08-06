class GroupingMailer < ActionMailer::Base
  default :from => "wattle@example.com"
  layout "mailer"

  def notify(grouping)
    @grouping = grouping
    @wat = grouping.wats.last
    @new_count = grouping.last_emailed_at.present? ? grouping.wats.where('wats.created_at > ?', grouping.last_emailed_at).count : grouping.wats.count

    @app_envs = @grouping.wats.pluck(:app_env).uniq
    mail :to => Watcher.pluck(:email), :subject => "[#{@wat.app_name}##{@wat.app_env[0..3]}] #{@wat.message}"
  end
end