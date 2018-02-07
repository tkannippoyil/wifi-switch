class WattBox

  USER = 'admin'
  PWD = ''
  IP = '192.168.1.107'

  AUTH = Base64.encode64 "#{USER}:#{PWD}"

  HEADERS = { 
    'Keep-Alive' => '300',
    'Connection' => 'keep-alive',
    'Authorization' => "Basic #{AUTH}",
    'User-Agent' => 'APP',
  }

  def self.all
    puts "calling http://#{IP}/wattbox_info.xml"

    response = HTTParty.get(
      "http://#{IP}/wattbox_info.xml", headers: HEADERS,
    )

    hash = response.parsed_response['request']
    
    hash['outlet_name'].split(',').map.with_index {|outlet, i|
      { id: i+1, name: outlet, address: i+1, status: hash['outlet_status'].split(',')[i] == '1' }
    }
  end

  def initialize(outlet)
    @outlet = outlet
  end

  def get(command)
    puts "calling http://#{IP}/control.cgi?outlet=#{@outlet}&command=#{command}"

    response = HTTParty.get(
      "http://#{IP}/control.cgi?outlet=#{@outlet}&command=#{command}",
      headers: HEADERS,
    )

    response
  end

  def turn_on()
    get 1
    { id: 1, name: 'Outlet 1', address: '1', status: true }
  end

  def turn_off()
    get 0
    { id: 1, name: 'Outlet 1', address: '1', status: false }
  end

  def restart()
    get 3
    { id: 1, name: 'Outlet 1', address: '1', status: true }
  end
end
