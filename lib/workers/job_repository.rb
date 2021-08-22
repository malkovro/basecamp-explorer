class JobRepository
  class PendingJob; end

  class FailedJob; end

  def self.mark_pending(job_id)
    REDIS.set(job_id, Marshal.dump(PendingJob.new))
  end

  def self.mark_failed(job_id)
    REDIS.set(job_id, Marshal.dump(FailedJob.new))
  end

  def self.store(job_id, result)
    REDIS.set(job_id, Marshal.dump(result))
  end

  def self.fetch(job_id)
    Marshal.load REDIS.get(job_id) # rubocop:disable Security/MarshalLoad
  end
end
