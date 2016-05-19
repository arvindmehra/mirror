class BatchNotifier
  include SuckerPunch::Job

  def perform(template)
    Notifier.trigger_for_batch(template)
  end

end