# coding: utf-8

class VmEnv

  def initialize(config)
    @config = config
  end

  def port
    # アプリで使用するポートを記述
    #@config.vm.network :forwarded_port, guest: 8080, host: 8080
  end

end
