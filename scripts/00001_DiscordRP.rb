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

    # --- RÉCUPÉRATION DES DONNÉES (SÉCURISÉE) ---
    details = "Menu Principal"
    state = "Pret a partir"

    begin
      # 1. Vérification de la Map
      # On utilise la variable que tu as testée avec F12
      current_id = ($game_map ? $game_map.map_id : 0) rescue 0
      
      if current_id > 0
        # On tente de récupérer le nom via l'environnement PSDK
        nom_lieu = ""
        if defined?(PFM) && PFM.game_state && PFM.game_state.env
          nom_lieu = PFM.game_state.env.get_current_zone_data.map_name.to_s rescue ""
        end
        
        details = nom_lieu.empty? ? "Exploration (Map #{current_id})" : nom_lieu
        
        # 2. Vérification des Pokémon
        # Ton log a montré que les pokémons sont dans gs.actors
        if defined?(PFM) && PFM.game_state && PFM.game_state.actors
          nb = PFM.game_state.actors.compact.size rescue 0
          state = "Equipe : #{nb} Pokemon"
        end
      end

      # --- ENVOI DISCORD ---
      puts "[DISCORD] Update -> #{details} | #{state}"
      
      payload = [
        state, details, 0, 0,
        "logo_large", "Pokémon Cinabre",
        "icon_small", "En voyage",
        "", 0, 0, "", "", "", 0
      ].pack('p2q2p5i2p3c')

      @f_update.call(payload)
      @f_run.call
    rescue => e
      puts "[DISCORD] ERREUR UPDATE : #{e.message}"
    end
  end
end

# Lancement dans un Thread (Processus séparé)
Thread.new do
  loop do
    DiscordRP.update
    sleep 10 # On rafraîchit toutes les 10 secondes
  end
end