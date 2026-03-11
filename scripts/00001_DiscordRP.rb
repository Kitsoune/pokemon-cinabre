module Fiddle
  def self.win32_last_socket_error=(code); end
end

require 'fiddle'

module DiscordRP
  ID = '1480212595293294632'

  def self.init
    return if @initialise
    begin
      @handle = Fiddle::Handle.new('discord-rpc.dll')
      @f_init = Fiddle::Function.new(@handle['Discord_Initialize'], [Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP, Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOID)
      @f_update = Fiddle::Function.new(@handle['Discord_UpdatePresence'], [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOID)
      @f_run = Fiddle::Function.new(@handle['Discord_RunCallbacks'], [], Fiddle::TYPE_VOID)
      @f_init.call(ID, nil, 1, nil)
      @initialise = true
      puts "[DISCORD] Initialisation DLL : OK"
    rescue => e
      puts "[DISCORD] ERREUR DLL : #{e.message}"
    end
  end

  def self.update
    init unless @initialise
    return unless @initialise

    details = "Menu Principal"
    state = "Région de Huaxia"

    begin
      if $game_map && $game_map.map_id > 0
        nom_lieu = PFM.game_state.env.current_zone_name rescue ""
        
        if nom_lieu.empty? || nom_lieu.include?("MAP")
          nom_lieu = $game_map.name.to_s rescue ""
        end

        details = (nom_lieu.empty? || nom_lieu.include?("MAP")) ? "Exploration (Map #{$game_map.map_id})" : nom_lieu
      end

      if PFM.game_state && PFM.game_state.actors
        nb = PFM.game_state.actors.compact.size rescue 0
        state = "Equipe : #{nb} Pokemon"
      end

      puts "[DISCORD] Update -> #{details} | #{state}"
      
      payload = [
        state,
        details,
        0, 0,
        "logo_large",
        "Pokemon Cinabre",
        "icon_small",
        "Fangame Français",
        "", 0, 0, "", "", "", 0
      ].pack('p2q2p5i2p3c')

      @f_update.call(payload)
      @f_run.call
    rescue => e
      puts "[DISCORD] ERREUR UPDATE : #{e.message}"
    end
  end
end

Thread.new do
  loop do
    DiscordRP.update
    sleep 10
  end
end