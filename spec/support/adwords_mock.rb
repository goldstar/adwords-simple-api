class AdwordsMock
  attr :skip_report_header, :skip_column_header, :skip_report_summary, :include_zero_impressions, :services
  def initialize
  end

  def service(name, version = nil)
    name = name.to_s.gsub(/_/,'').downcase.to_sym
    @@services ||= {}
    @@services[name] ||= ServiceMock.new(name)
  end

  class ServiceMock
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def get(payload)
      warn "called get with payload:\n#{payload.inspect}"
      return {}
    end

    def mutate(payload)
      warn "called mutate with payload:\n#{payload.inspect}"
      return {}
    end

  end
end
